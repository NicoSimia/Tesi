//#if UNITY_SWITCH || UNITY_EDITOR || NN_PLUGIN_ENABLE

using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace Package.CustomLibrary
{
    public static class SwitchSaveDataHelper
    {
        private const string MountName = "save";
        private static bool _isMounted;
        private static bool _hasUserHandle;
        private static readonly Dictionary<string, string> _lastWrittenContent = new Dictionary<string, string>();
        private static int _uncommittedWrites;
        public static bool IsMounted => _isMounted;

        public static bool Initialize() { }

        private static bool AcquireUser() { }

        private static void CloseUserHandle() { }

        public static void Unmount() { }

        public static void WriteFile(string fileName, int saveVersion, string content) { }

        public static bool Commit() { }

        public static string ReadFile(string fileName, int saveVersion) { }
    }
        // Deletes an entire save slot (the Data_<saveVersion> directory and its files) and
        // commits so the deletion persists. Returns true only if a slot was actually deleted.
        public static bool DeleteSlot(int saveVersion)
        {
            if (!_isMounted && !Initialize())
            {
                Debug.LogError("[Switch] Save data unavailable, cannot delete slot " + saveVersion + "\n");
                return false;
            }

            string dirPath = MountName + ":/Save/Data_" + saveVersion;

            // Nothing to delete if the slot directory doesn't exist.
            nn.fs.EntryType entryType = default(nn.fs.EntryType);
            if (!nn.fs.FileSystem.GetEntryType(ref entryType, dirPath).IsSuccess())
                return false;

            nn.Result result = nn.fs.Directory.DeleteRecursively(dirPath);
            if (!result.IsSuccess())
            {
                Debug.LogError("[Switch] DeleteRecursively failed " + dirPath + ": " + result + "\n");
                return false;
            }

            // Like writes, a deletion is not persisted to the partition until committed.
            result = nn.fs.FileSystem.Commit(MountName);
            if (!result.IsSuccess())
            {
                Debug.LogError("[Switch] Commit failed " + MountName + ": " + result + "\n");
                return false;
            }

            // The slot's files are gone; drop their cached content so a future save of a recreated
            // file is treated as new (always written) rather than wrongly skipped as "unchanged".
            // This Commit persisted the deletion, so there are no pending writes left either.
            _lastWrittenContent.Clear();
            _uncommittedWrites = 0;

            Debug.Log("[Switch] Deleted and committed " + dirPath + "\n");
            return true;
        }

        private static string BuildFilePath(string fileName, int saveVersion)
        {
            return MountName + ":/Save/Data_" + saveVersion + "/" + fileName + ".json";
        }

        private static void EnsureDirectory(string path)
        {
            nn.fs.EntryType entryType = default(nn.fs.EntryType);
            nn.Result result = nn.fs.FileSystem.GetEntryType(ref entryType, path);
            if (!result.IsSuccess())
                nn.fs.Directory.Create(path);
        }
    }
}

//#endif
