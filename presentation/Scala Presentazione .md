# Scaletta

## Diapositiva 1
Buongiorno a tutti. Oggi presento il lavoro svolto durante il mio stage, che è anche l'argomento della tesi: l'adattamento di "Lost in the Dungeon" su Nintendo Switch, uno stage di otto settimane svolto presso l'azienda Eggon.

## Diapositita 2
La presentazione si articola in quattro parti. Prima parlerò dell'azienda e del prodotto su cui ho lavorato. Poi descriverò gli obiettivi dello stage e il metodo di lavoro adottato, distinguendo tra il piano iniziale e ciò che è effettivamente emerso durante le otto settimane. La terza parte è il cuore tecnico della presentazione: la migrazione dell'engine, l'implementazione della navigazione da controller, e la certificazione Nintendo Switch. Chiuderò con un resoconto finale, sia sulle competenze acquisite sia su dati oggettivi — quante attività ho completato, quante scene ho reso navigabili, quanti test di certificazione ho superato.

## Diapositiva 3 (Azienda pt.1)
L'azienda presso cui ho svolto lo stage si chiama Eggon, una software house con sede a Padova, fondata a fine 2015 da due startupper di ritorno dagli Stati Uniti. Conta circa trenta dipendenti e opera su tre settori principali: il Digital Health, con l'app MioPediatra che connette centinaia di migliaia di genitori con i pediatri; l'IoT e industria 5.0, per l'efficientamento energetico e produttivo delle aziende; e l'Insurtech, con la piattaforma MyWide per la gestione di polizze assicurative. C'è però un quarto ambito, più piccolo e fermo dal 2018: lo sviluppo videoludico. Ed è proprio su questo che si concentra il mio stage.

## Diapositiva 4 (Azienda pt.2)
Lost in the Dungeon, o LITD, è l'ultimo dei quattro giochi sviluppati da Eggon, e l'unico realizzato in completa autonomia, senza collaborazioni esterne. È un gioco di carte che mescola meccaniche RPG e da dungeon crawler, rilasciato a marzo 2018 su PC, tramite Steam, e su mobile — versione poi rimossa dal Play Store per un cambio di policy sugli asset supportati. Al momento in cui è iniziato lo stage, il progetto era fermo da anni: lo stack tecnologico era datato, la versione di Unity non più supportata, e persino l'integrazione con Steam non funzionava più correttamente. È da questa situazione che nascono gli obiettivi dello stage, di cui parlo nella prossima sezione.

## Diapositiva 5 e 6 (AdR)
Gli obiettivi dello stage si articolano in tre attività, sequenziali e non indipendenti tra loro. Le prime due settimane, da solo, le ho dedicate alla migrazione dell'engine, da Unity 2017 a Unity 6, con l'obiettivo di zero errori di compilazione. Questa migrazione era un prerequisito tecnico: solo dopo aver aggiornato l'engine potevo adottare il nuovo sistema di input di Unity, condizione necessaria per implementare la navigazione da controller su tutte le sei scene del gioco. Alla terza settimana si è unito un secondo stagista, e da lì abbiamo lavorato in coppia su navigazione controller e certificazione Nintendo Switch in parallelo — quest'ultima è l'obiettivo a maggior rischio, perché dipende da requisiti imposti dal platform holder e non pienamente sotto il nostro controllo. Il tutto entro un vincolo fisso di otto settimane, mantenendo sempre la compatibilità con salvataggi e funzionalità già esistenti su PC e mobile.

Per organizzare il lavoro non abbiamo adottato metodologie agili come Scrum, che l'azienda usa sugli altri progetti: il costo di una struttura formale sarebbe stato sproporzionato rispetto alla dimensione del team, due persone, e al progetto stesso. La pianificazione si basava su giorni di presenza fissi in azienda — necessari anche per accedere fisicamente al Dev Kit Nintendo Switch, disponibile solo in sede — e su confronti informali con il tutor aziendale ogni volta che completavamo un'attività significativa. Per tracciare il lavoro abbiamo scelto una soluzione leggera: un file Todo in formato markdown, versionato insieme al codice, organizzato in categorie identificate da lettera e numero. Ogni commit che implementava una voce del Todo ne riportava il riferimento, ad esempio "td-C3" — una forma di documentazione incrementale che compensava l'assenza di uno strumento di issue tracking professionale. Con il mio collega abbiamo diviso il lavoro per scena, non per tipo di attività, per evitare di modificare gli stessi file in parallel

## Diapositiva 7 e 8
La migrazione dell'engine è stata la prima attività, portata a termine da solo nelle prime due settimane. Il salto era di sei versioni principali di Unity, dal 2017 alla versione 6, con potenziali incompatibilità distribuite su motore grafico, sistema di input e librerie di terze parti. Ho scelto di dividere l'aggiornamento in due passaggi, inserendo Unity 2021 come tappa intermedia invece di saltare direttamente all'ultima versione: saltare subito a una versione troppo recente rischiava di far perdere traccia di errori, perché le versioni più nuove rimuovono il codice ormai troppo datato invece di segnalarlo come deprecato. Tra i problemi più concreti: la libreria ShaderForge, dove ho dovuto intervenire direttamente sul codice generato delle shader per risolvere un problema di trasparenza rotta; e Steamworks.NET, che ho reimportato tramite il Package Manager, introducendo però un nuovo problema — la libreria apriva il client Steam anche durante i test nell'editor, risolto escludendone l'inizializzazione tramite direttive di compilazione condizionale.

Per la navigazione da controller, la scelta progettuale centrale riguarda la modalità di collegamento tra gli elementi dell'interfaccia. Unity offre una modalità automatica, che collega ogni pulsante ai quattro più vicini nelle direzioni cardinali, ma senza tener conto della logica dell'interfaccia. L'ho sostituita con la modalità Explicit, configurando manualmente, scena per scena, i collegamenti direzionali corretti — quella che vedete a sinistra è la finestra Inspector con questa configurazione. Per rendere sempre riconoscibile il focus, ho poi implementato un cursore grafico a forma di mano, come componente persistente che legge a ogni frame la selezione corrente dell'EventSystem di Unity e si posiziona sul centro dell'elemento selezionato, convertito in coordinate schermo — è il codice a destra.

La certificazione Nintendo Switch imponeva sei test ufficiali sul sistema di salvataggio. Il file system della console funziona in modo sostanzialmente diverso da un PC: prima di scrivere, serve montare un'area legata all'utente tramite l'API dedicata, poi i dati passano attraverso un buffer, e solo un'operazione di commit li rende persistenti — è la logica implementata nella classe a sinistra. Il test più critico, quello sul Write Access Count, verificava che non si superasse una soglia di operazioni di scrittura al minuto: il codice originale, con un commit a ogni singola modifica, arrivava a oltre 160 operazioni al minuto, contro una soglia di circa 32. Ho risolto il problema con tre ottimizzazioni: raggruppare le modifiche in una scrittura ritardata di trenta secondi, saltare la scrittura quando il contenuto non è cambiato, e riaprire il file esistente invece di ricrearlo ogni volta.

## Diapositiva 9 e 10
Resoconto oggettivo con metriche valide:
- Numero errori compilazione
- Scene rese accessibili tramite controller
- Test Nintendo passati

Crescita personale:
- Comprensione C# e Unity
- Pattern per videogiochi (Repo)
- Lavorare sotto direttive e rispettare standard del mercato

Bilancio quantitativo:
- Grafico a torta con spartimento ore
- Linee di codice scritte
- Documenti redatti (insieme anche a quelli delle statistiche per dei futuri aggiornmenti)