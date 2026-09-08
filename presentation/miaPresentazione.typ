// =============================================================================
// VARIABILI GLOBALI (Modifica solo queste righe!)
// =============================================================================
#let autore        = "Simionato Nicola"
#let matricola     = "2113190"
#let relatore      = "Prof. Tullio Vardanega"
#let titolo-esteso = "Adattamento di Lost in the Dungeon su Nintendo Switch"
#let titolo-breve  = "Porting LITD"
#let data-laurea   = "24 Settembre 2026"

// =============================================================================
// CONFIGURAZIONE COLORI E STILE
// =============================================================================
#let primary = rgb("#1B4332")    // Verde Scuro
// #let accent  = rgb("#8B1E1E")    // Rosso Scuro (alto contrasto)
#let accent = rgb("#0052CC")
#let text-color = rgb("#222222") // Grigio scuro
#let bg-box = rgb("#F4F6F4")     // Sfondo chiaro per schede

#let the-slide-title = state("slide-title", "")
#let the-section = state("section", "")

// Helper per creare placeholder visivi per Screenshot / Diagrammi / Codice
#let img-box(width: 100%, height: 9.5em, title: "Screenshot / Schema") = {
  rect(
    width: width,
    height: height,
    fill: bg-box,
    stroke: 1.5pt + primary.lighten(40%),
    radius: 0.4em,
    align(center + horizon)[
      #text(size: 13pt, fill: primary, weight: "bold")[#title] \
      #v(0.2em)
      #text(size: 10pt, fill: luma(120))[Inserire qui l'immagine con )]
    ]
  )
}

// Configurazione globale della pagina
#let conf(doc) = {
  set document(title: titolo-esteso, author: autore)
  set text(font: "Liberation Sans", size: 18pt, fill: text-color)
  set list(marker: text(fill: accent)[•])
  
  set page(
    paper: "presentation-16-9",
    margin: (top: 5.6em, bottom: 2.2em, left: 1.5em, right: 1.5em),
    
    // HEADING SUPERIORE (Traccia sezione e titolo slide)
    header: context {
      let p = counter(page).get().first()
      if p > 1 {
        grid(
          columns: (1.2fr, 2.5fr, 1fr),
          align(left + horizon)[
            #text(size: 11pt, weight: "bold", fill: primary)[#the-section.get()]
          ],
          align(center + horizon)[
            #text(size: 15pt, weight: "bold", fill: text-color)[#the-slide-title.get()]
          ],
          align(right + horizon)[#image("../img/logo_unipd.jpeg", height: 40pt)]
        )
        v(-0.3em)
        line(length: 100%, stroke: 0.8pt + primary.lighten(70%))
      }
    },
    
    // FOOTER VERDE SCURO EDGE-TO-EDGE (Assente in prima pagina)
    footer: context {
      let p = counter(page).get().first()
      if p > 1 {
        // Rettangolo pieno verde da sinistra a destra
        place(
          top + left,
          dx: -1.5em,
          dy: -0.4em,
          rect(width: 100% + 3.0em, height: 2.2em, fill: primary, radius: 0pt)
        )
        
        set text(size: 11pt, fill: white)
        if p == 2 {
          grid(
            columns: (1fr, 1.5fr, 1fr),
            align(left + horizon)[#autore — #data-laurea],
            align(center + horizon)[#titolo-breve],
            align(right + horizon)[Indice]
          )
        } else {
          let current = p - 2
          let total = counter(page).final().first() - 2
          grid(
            columns: (1fr, 1.5fr, 1fr),
            align(left + horizon)[#autore — #data-laurea],
            align(center + horizon)[#titolo-breve],
            align(right + horizon)[#current di #total]
          )
        }
      }
    }
  )
  doc
}

// Slide Iniziale (Titolo)
#let title-slide() = {
  page(header: none, footer: none, margin: (top: 1.5em, bottom: 1.5em, left: 1.5em, right: 1.5em))[
    #grid(
      columns: (1fr, auto),
      align(left)[
        #text(size: 12pt, fill: primary, weight: "bold")[
          Università degli Studi di Padova \
          Dipartimento di Matematica "Tullio Levi-Civita" \
          Corso di Laurea in Informatica
        ]
      ],
      align(right + horizon)[#image("../img/logo_unipd.jpeg", width: 100pt)]
    )
    #v(1.2fr)
    #align(center)[
      #text(size: 24pt, weight: "bold", fill: primary)[#titolo-esteso]
    ]
    #v(1.5fr)
    #grid(
      columns: (1fr, 1fr),
      align(left)[
        #text(size: 13pt, fill: luma(100))[Relatore:] \
        #text(size: 15pt, weight: "bold", fill: text-color)[#relatore]
      ],
      align(right)[
        #text(size: 13pt, fill: luma(100))[Candidato:] \
        #text(size: 15pt, weight: "bold", fill: text-color)[#autore \ Matricola #matricola]
      ]
    )
    #v(0.8fr)
    #align(center)[
      #text(size: 13pt, fill: primary, weight: "bold")[Esame di Laurea — #data-laurea]
    ]
  ]
}

// Costruttore generico per le slide successive
#let slide(title: "", section: none, content) = {
  the-slide-title.update(title)
  if section != none {
    the-section.update(section)
  }
  pagebreak(weak: true)
  content
}

#show: conf

// =============================================================================
// 0. DIAPOSITIVA 1 & 2: TITOLO E INDICE
// =============================================================================

#title-slide()

#slide(title: "Indice dei Contenuti", section: "Indice")[
  #v(6em)
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 1em,
    align: center + horizon,
    
    circle(radius: 1.6em, fill: primary)[#text(fill: white, weight: "bold", size: 18pt)[1]],
    circle(radius: 1.6em, fill: primary)[#text(fill: white, weight: "bold", size: 18pt)[2]],
    circle(radius: 1.6em, fill: primary)[#text(fill: white, weight: "bold", size: 18pt)[3]],
    circle(radius: 1.6em, fill: accent)[#text(fill: white, weight: "bold", size: 18pt)[4]],
    
    text(size: 15pt, weight: "bold", fill: primary)[L'Azienda],
    text(size: 15pt, weight: "bold", fill: primary)[Analisi dei \ Requisiti],
    text(size: 15pt, weight: "bold", fill: primary)[Sviluppo Tecnico],
    text(size: 15pt, weight: "bold", fill: accent)[Resoconto & \ Bilancio]
  )
]

// =============================================================================
// SEZIONE 1: L'AZIENDA (Slide 3 e 4)
// =============================================================================

#slide(title: "L'Azienda: Eggon Software House", section: "1. L'Azienda")[
  #v(0.3em)
  #grid(
    columns: (32%, 68%),
    gutter: 1.8em,
    align: horizon,
    
    // COLONNA SINISTRA: Logo dell'Azienda
    align(center + horizon)[
      // Sostituire con: #image("../img/eggon_logo.png", width: 100%)
      #image("../img/eggon_logo.png", width: 100%)
    ],

    // COLONNA DESTRA: Le due strisce
    grid(
      columns: (1fr),
      row-gutter: 1.0em,
      
      // STRISCIA 1: Info Generali (Sede, Dipendenti, Origine)
      block(
        fill: primary.lighten(92%),
        stroke: (left: 4pt + primary),
        inset: 0.9em,
        radius: (right: 0.4em),
        width: 100%
      )[
        #grid(
          columns: (1fr, 1fr, 1fr),
          align: horizon,
          [
            #text(size: 10pt, fill: luma(100))[Sede] \
            #text(size: 13pt, weight: "bold", fill: primary)[Padova]
          ],
          [
            #text(size: 10pt, fill: luma(100))[Organico] \
            #text(size: 13pt, weight: "bold", fill: primary)[30 Dipendenti]
          ],
          [
            #text(size: 10pt, fill: luma(100))[Origine] \
            #text(size: 13pt, weight: "bold", fill: primary)[Experience USA]
          ]
        )
      ],

      // STRISCIA 2: Settori di Operatività
      block(
        fill: bg-box,
        stroke: (left: 4pt + accent),
        inset: 1em,
        radius: (right: 0.4em),
        width: 100%
      )[
        #text(weight: "bold", fill: accent, size: 14pt)[Settori Chiave di Business]
        #v(0.3em)
        - *Digital Health* //: App *mioPediatra* per canale diretto genitori-medico
        - *IoT & Industria 5.0* // : Analytics dati smart per efficientamento energetico
        - *Insurtech* //: PWA *MyWide* per gestione e digitalizzazione polizze
        - *Sviluppo Videoludico*
      ]
    )
  )
]

// =============================================================================
// SEZIONE 1: L'AZIENDA (Slide 2/2 — Il progetto: Lost in the Dungeon)
// =============================================================================

// Helper: box d'angolo con freccia verso il centro
#let corner-box(color: primary, arrow: "→", label: "", value: [], align-arrow: left) = {
  block(
    fill: color.lighten(90%),
    stroke: (left: 4pt + color),
    inset: 0.8em,
    radius: (right: 0.4em),
    width: 100%
  )[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.5em,
      align: horizon,
      text(size: 20pt, fill: color, weight: "bold")[#arrow],
      [
        #text(size: 10pt, fill: luma(100))[#label] \
        #text(size: 13pt, weight: "bold", fill: color)[#value]
      ]
    )
  ]
}

#slide(title: "Il Progetto: Lost in the Dungeon", section: "1. L'Azienda")[
  #v(0.3em)
  #grid(
    columns: (0.7fr, 1.3fr, 0.7fr),
    rows: (auto, auto, auto),
    column-gutter: 0.3em,
    row-gutter: 0.3em,
    align: horizon,

    // Riga 1
    corner-box(color: primary, arrow: "↘", label: "Genere", value: [Card Game + \ Dungeon Crawler]),
    [],
    corner-box(color: primary, arrow: "↙", label: "Rilascio", value: [Marzo 2018]),

    // Riga 2: immagine centrale
    [],
    align(center)[
      // Sostituire con l'immagine reale: Fig. 1.2 della tesi (Fonte: Steam)
      #image("../img/litd_logo.png", width: 55%)
      #v(0.2em)
      #text(size: 9pt, fill: luma(120), style: "italic")[Fonte: pagina Steam del prodotto]
    ],
    [],

    // Riga 3
    corner-box(color: accent, arrow: "↗", label: "Piattaforme", value: [PC (Steam) \ Mobile (rimosso)]),
    [],
    corner-box(color: accent, arrow: "↖", label: "Sviluppo", value: [4° gioco Eggon \ unico indipendente])
  )
]

// =============================================================================
// SEZIONE 2: ANALISI DEI REQUISITI (Slide 5 e 6)
// =============================================================================

#slide(title: "Analisi Macro: I Tre Obiettivi Principali", section: "2. Analisi dei Requisiti")[
  #v(0.2em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    block(fill: primary.lighten(92%), stroke: 1.5pt + primary, radius: 0.4em, inset: 1em)[
      #align(center)[#text(weight: "bold", fill: primary)[1. Debito Tecnico]]
      #v(0.4em)
      - Eliminazione dipendenze obsolete
      - Risoluzione warning e API deprecate post-upgrade
    ],
    block(fill: primary.lighten(92%), stroke: 1.5pt + primary, radius: 0.4em, inset: 1em)[
      #align(center)[#text(weight: "bold", fill: primary)[2. Navigazione Controller]]
      #v(0.4em)
      - Mappatura completa Joy-Con / Pro Controller
      - Navigazione UI tramite D-Pad e Stick
    ],
    block(fill: accent.lighten(90%), stroke: 1.5pt + accent, radius: 0.4em, inset: 1em)[
      #align(center)[#text(weight: "bold", fill: accent)[3. Certificazione]]
      #v(0.4em)
      - Conformità alle linee guida Nintendo (TRC/Lotcheck)
      - Gestione profilo utenti e salvataggi
    ]
  )
]

#slide(title: "Gestione Dinamica dell'Analisi", section: "2. Analisi dei Requisiti")[
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1.5em,
    align: horizon,
    [
      - *Pianificazione Iterativa*
        - Scomposizione dei requisiti macro in Task giornalieri
        - Valutazione dell'impatto ad ogni cambio di versione engine
      - *Raffinamento del Backlog*
        - Prioritizzazione dei blocchi di compilazione bloccanti
        - Gestione dinamica degli imprevisti riscontrati nel codice legacy
      - *Verifica Continua*
        - Allineamento giornaliero interno al team a due componenti
    ],
    img-box(height: 10em, title: "Workflow Agile / Board Task")
  )
]

// =============================================================================
// SEZIONE 3: SVILUPPO (Slide 7 e 8)
// =============================================================================

#slide(title: "Migrazione dell'Engine: Pipeline di Upgrade", section: "3. Sviluppo")[
  // 1. TIMELINE ORIZZONTALE DELLE VERSIONI
  #grid(
    columns: (1fr, auto, 1.2fr, auto, 1fr),
    align: center + horizon,
    gutter: 0.4em,
    
    // Nodo 1: Unity 2017
    block(fill: bg-box, stroke: 1.5pt + primary.lighten(40%), radius: 0.4em, inset: 0.8em, width: 100%)[
      #text(size: 14pt, weight: "bold", fill: primary)[Unity 2017] \
      #text(size: 9pt, fill: luma(120))[Legacy Codebase]
    ],
    
    // Freccia 1
    text(size: 20pt, fill: accent, weight: "bold")[$arrow.r$],
    
    // Nodo 2: Unity 2021
    block(fill: accent.lighten(90%), stroke: 1.5pt + accent, radius: 0.4em, inset: 0.8em, width: 100%)[
      #text(size: 14pt, weight: "bold", fill: accent)[Unity 2021] \
      #text(size: 9pt, fill: accent)[LTS Intermedio]
    ],
    
    // Freccia 2
    text(size: 20pt, fill: primary, weight: "bold")[$arrow.r$],
    
    // Nodo 3: Unity 6
    block(fill: primary, radius: 0.4em, inset: 0.8em, width: 100%)[
      #text(size: 14pt, weight: "bold", fill: white)[Unity 6] \
      #text(size: 9pt, fill: white.darken(15%))[Target Finale]
    ]
  )

  #v(0.6em)

  // 2. SCHEDE DI APPROFONDIMENTO (DEEP DIVE PER OGNI STEP)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    
    // Approfondimento Passaggio 1
    block(
      fill: bg-box,
      stroke: (top: 3.5pt + accent, left: 1pt + luma(200), right: 1pt + luma(200), bottom: 1pt + luma(200)),
      inset: 0.9em,
      radius: 0.4em,
      width: 100%
    )[
      #grid(
        columns: (auto, 1fr),
        gutter: 0.5em,
        align: horizon,
        text(fill: accent, weight: "bold", size: 12pt)[STEP 1:],
        text(weight: "bold", size: 12pt, fill: text-color)[2017 $arrow.r$ 2021 (Refactoring Breaking Changes)]
      )
      #v(0.3em)
      - *API deprecate e namespace rimossi*
      - *Rimozione gestione legacy dei file OBB*
      - *Incompatibilità dei pacchetti di terze parti*
    ],
    
    // Approfondimento Passaggio 2
    block(
      fill: bg-box,
      stroke: (top: 3.5pt + primary, left: 1pt + luma(200), right: 1pt + luma(200), bottom: 1pt + luma(200)),
      inset: 0.9em,
      radius: 0.4em,
      width: 100%
    )[
      #grid(
        columns: (auto, 1fr),
        gutter: 0.5em,
        align: horizon,
        text(fill: primary, weight: "bold", size: 12pt)[STEP 2:],
        text(weight: "bold", size: 12pt, fill: text-color)[2021 $arrow.r$ Unity 6 (Ottimizzazione & SDK)]
      )
      #v(0.3em)
      - *Ripristino e integrazione Steamworks.NET*
      - *Allineamento alle API e librerie native Nintendo*
      - *Risoluzione warning di compilazione e Render Pipeline*
    ]
  )
]

#slide(title: "Navigazione da Controller", section: "3. Sviluppo")[
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 1.5em,
    align: horizon,
    [
      - *Refactoring dell'Interfaccia Utente*
        - Transizione da input Pointer/Mouse a *InputSystem* a eventi
        - Mappatura del focus dinamico per tutti i menu di gioco
      - *Gestione dello Stato UI*
        - Prevenzione del perdita di focus nell'interfaccia
        - Gestione overlay di pausa e finestre di dialogo native
    ],
    img-box(height: 10.5em, title: "Screenshot Scene UI / Navigazione Controller")
  )
]

#slide(title: "Testing e Integrazione SDK Nintendo", section: "3. Sviluppo")[
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 1.5em,
    align: horizon,
    [
      - *Integrazione API Native (FS Nintendo)*
        - Gestione del File System per salvataggi asincroni
        - Conformità ai vincoli di memoria e tempo d'accesso
      - *Suite di Test Interna*
        - Test automatici di stabilità durante le sessioni prolungate
        - Verifica della gestione del cambio utente e sospensione console
    ],
    img-box(height: 10.5em, title: "Screenshot Codice Test / Modulo FS")
  )
]

// =============================================================================
// SEZIONE 4: RESOCONTO & BILANCIO (Slide 9 e 10)
// =============================================================================

#slide(title: "Risultati e Crescita Professionale", section: "4. Resoconto")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    [
      #text(weight: "bold", fill: primary)[Metriche Oggettive]
      #v(0.3em)
      #block(fill: bg-box, stroke: (left: 4pt + primary), inset: 0.8em, radius: (right: 0.3em))[
        - *0 Errori di Compilazione* post-upgrade
        - *100% Scene UI* accessibili da controller
        - *Test Nintendo Superati* (Lotcheck TRC)
      ]
    ],
    [
      #text(weight: "bold", fill: accent)[Crescita Personale]
      #v(0.3em)
      #block(fill: bg-box, stroke: (left: 4pt + accent), inset: 0.8em, radius: (right: 0.3em))[
        - *C\# & Unity*: Padronanza avanzata
        - *Game Patterns*: Pattern Repository, State
        - *Standard industriali*: Rispetto direttive rigide di pubblicazione console
      ]
    ]
  )
]

#slide(title: "Bilancio Quantitativo", section: "4. Resoconto")[
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 1.5em,
    [
      #text(weight: "bold", size: 15pt, fill: primary)[Ripartizione Ore (Totale 300h)]
      #v(0.5em)
      #grid(
        columns: (auto, 1fr, auto),
        row-gutter: 0.6em,
        column-gutter: 0.8em,
        align: horizon,
        rect(width: 0.9em, height: 0.9em, fill: primary), text(size: 11pt)[Analisi & Upgrade Engine], text(size: 11pt, weight: "bold")[60 h],
        rect(width: 0.9em, height: 0.9em, fill: primary.lighten(30%)), text(size: 11pt)[Refactoring UI & Controller], text(size: 11pt, weight: "bold")[90 h],
        rect(width: 0.9em, height: 0.9em, fill: accent), text(size: 11pt)[Integrazione SDK & FS Test], text(size: 11pt, weight: "bold")[80 h],
        rect(width: 0.9em, height: 0.9em, fill: accent.lighten(30%)), text(size: 11pt)[Correzione Debito Tecnico], text(size: 11pt, weight: "bold")[40 h],
        rect(width: 0.9em, height: 0.9em, fill: luma(100)), text(size: 11pt)[Documentazione & Report], text(size: 11pt, weight: "bold")[30 h]
      )
    ],
    [
      #text(weight: "bold", size: 15pt, fill: accent)[Metriche di Prodotto]
      #v(0.5em)
      #block(fill: bg-box, stroke: 1pt + primary.lighten(50%), radius: 0.4em, inset: 0.8em)[
        - *Righe di codice (LOC)* scritte/rifattorizzate
        - *Scene di gioco* rese completamente conformi
        - *Documenti redatti*: Relazione di Tesi + Report per aggiornamenti futuri
      ]
    ]
  )
  #v(0.8em)
  #align(center)[
    #text(size: 16pt, weight: "bold", fill: primary)[Grazie per l'attenzione!]
  ]
]
