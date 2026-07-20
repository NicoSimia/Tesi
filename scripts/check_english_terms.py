import os
import re
import sys

# Determina la cartella radice del progetto (parent directory rispetto a dove sta lo script)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))

def load_english_words(txt_filename="english_words.txt"):
    """
    Carica i termini inglesi dal file TXT situato nella radice del progetto.
    """
    txt_path = os.path.join(PROJECT_ROOT, txt_filename)
    if not os.path.exists(txt_path):
        print(f"⚠️  Errore: Il file '{txt_path}' non è stato trovato nella radice!")
        sys.exit(1)
    
    terms = set()
    with open(txt_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                terms.add(line.lower())
    return terms

def get_ignored_spans(raw_content):
    """
    Restituisce gli intervalli (start, end) del testo racchiuso in \textit{...} 
    oppure contenuto nei comandi del glossario (es. \gls{...}, \Gls{...}, \glspl{...}, ecc.).
    """
    spans = []
    
    # 1. Match per \textit{...}
    textit_pattern = r'\\textit\{([^}]*)\}'
    for match in re.finditer(textit_pattern, raw_content):
        spans.append((match.start(1), match.end(1)))
        
    # 2. Match per comandi glossario: \gls{...}, \Gls{...}, \glspl{...}, \Glspl{...}
    gls_pattern = r'\\[gG]ls(?:pl)?\{([^}]*)\}'
    for match in re.finditer(gls_pattern, raw_content):
        spans.append((match.start(1), match.end(1)))
        
    return spans

def is_inside_ignored_span(start, end, ignored_spans):
    """
    Verifica se la posizione (start, end) ricade all'interno di un \textit{} o di un \gls{}.
    """
    return any(s_start <= start and end <= s_end for s_start, s_end in ignored_spans)

def check_missing_textit(raw_content, known_terms):
    """
    Trova TUTTE le occorrenze dei termini noti che compaiono nel testo ma NON sono in \textit{} o \gls{}.
    """
    ignored_spans = get_ignored_spans(raw_content)
    missing_textit = []
    
    # Ordina i termini dal più lungo al più corto per evitare falsi match parziali
    sorted_terms = sorted(known_terms, key=len, reverse=True)
    
    for term in sorted_terms:
        pattern = r'\b' + re.escape(term) + r'\b'
        for match in re.finditer(pattern, raw_content, re.IGNORECASE):
            start, end = match.start(), match.end()
            if not is_inside_ignored_span(start, end, ignored_spans):
                line_no = raw_content[:start].count('\n') + 1
                missing_textit.append((line_no, match.group(0)))
                
    # Ordina i risultati per numero di riga
    missing_textit.sort(key=lambda x: x[0])
    return missing_textit

def main():
    known_terms = load_english_words("english_words.txt")
    print(f"📖 Caricati {len(known_terms)} termini da 'english_words.txt'.\n")
    
    has_warnings = False
    
    # Scansiona tutti i file .tex partendo dalla radice del progetto
    for root, _, files in os.walk(PROJECT_ROOT):
        for file in sorted(files):
            if file.endswith('.tex'):
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, PROJECT_ROOT)
                
                with open(filepath, 'r', encoding='utf-8') as f:
                    raw_content = f.read()
                
                missing_textit = check_missing_textit(raw_content, known_terms)
                
                if missing_textit:
                    has_warnings = True
                    print(f"📄 File: {rel_path}")
                    for line_no, found_str in missing_textit:
                        print(f"   [Riga {line_no}] '{found_str}'")
                    print()
                    
    if not has_warnings:
        print("✅ Tutti i termini inglesi presenti nella lista sono correttamente racchiusi in \\textit{} o gestiti tramite \\gls{}!")

if __name__ == "__main__":
    main()