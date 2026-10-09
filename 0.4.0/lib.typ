#import "@local/letter:0.4.0": *

// Custom functions for layouting
#let pad-text(
  input,
  width,
  symbol: " ",
) = {
  if input.has("text") == false {
    str(3 * " ")
  } else {
    let input-string = input.at("text")
    let input-length = input-string.len()
    let symbols-needed = width - input-length

    if symbols-needed > 0 {
      str(symbols-needed * symbol + input-string)
    } else {
      input-string
    }
  }
}

#let number-boxes(
  input,
  input-width,
  box-breite: 13pt,
  box-hoehe: 13pt,
  nudge: 3pt,
) = {
  let input-processed = {
    if input == [] {
      input-width * " "
    } else {
      pad-text(input, input-width)
    }
  }


  let result = for i in input-processed {
    box(
      align(i, center + horizon),
      stroke: (paint: black, thickness: 0.3pt),
      width: box-breite,
      height: box-hoehe,
    )
  }

  box()[
    #set text(font: "DejaVu Sans Mono")
    #move(
      result,
      dy: nudge,
    )
  ]
}

#let raw-text(size: 9pt, body) = {
  set text(font: "DejaVu Sans Mono", size: size)
  body
}


#let checkbox(feature, input, size: 12pt, line-thickness: 0.3pt, nudge: 2pt) = {
  if feature not in input {
    box(
      move(dy: nudge)[
        #square(size: size, stroke: line-thickness)
      ],
    )
    h(2mm)
  } else if feature in input {
    box(
      move(dy: nudge)[
        #square(size: size, stroke: line-thickness)[
          #set align(center + horizon)
          #move(raw-text(sym.times, size: 15pt), dy: -0.5pt)
        ]
      ],
    )
    h(2mm)
  }
}

#let vbox(
  content,
  vbox-corner: 20pt,
  clear-dist-vert: 3.5cm - 2 * 20pt,
  clear-dist-hor: 262.21pt - 2 * 20pt,
  line-thickness: 0.3pt,
) = [
  #box(
    width: 269.29pt - 0.25cm,
    height: 3.5cm,
    stroke: (
      x: stroke(
        dash: (vbox-corner, clear-dist-vert),
        thickness: line-thickness,
      ),
      y: stroke(
        dash: (vbox-corner, clear-dist-hor),
        thickness: line-thickness,
      ),
    ),
    inset: (left: 1cm),
  )[
    #set align(horizon)
    #raw-text(content, size: 10pt)
  ]
]

#let format-date(datum) = {
  let datum-tag = datum.at("text").slice(0, count: 2)
  let datum-monat = datum.at("text").slice(3, count: 2)
  let datum-jahr = datum.at("text").slice(8, count: 2)
  datum-tag + datum-monat + datum-jahr
}

// Document
#let single-ptv-1(
  krankenkasse: none,
  krankenkasse-adresse: none,
  vorname: none,
  nachname: none,
  geburtsdatum: none,
  adresse: none,
  vnummer: hide[vnummer],
  therapeut: [],
  arztregister-nr: [],
  praxisadresse: [],
  checks: (),
  datum: [],
  ausfertigung: (),
  body,
) = [
  #let angaben-groesse = 7pt
  #set text(font: "Roboto", size: 10pt)
  #set page(margin: 1cm)
  #let line-thickness = 0.3pt
  #let vbox-content = [
    #krankenkasse\
    #krankenkasse-adresse
  ]
  #let datum-formatiert = format-date(datum)


  // Document
  #grid(
    columns: 2,
    column-gutter: 0.5cm,
    [
      #table(
        columns: 1,
        stroke: (paint: black, thickness: line-thickness),
        [
          #text(size: angaben-groesse)[Krankenkasse]\
          #raw-text(krankenkasse)
        ],

        [
          #grid(
            columns: 2 * (1fr,),
            [
              #text(size: angaben-groesse)[Name, Vorname des/der Versicherten]\
              #raw-text(nachname)\
              #raw-text(vorname)\
              #raw-text(adresse)
            ],
            [
              #set align(right + bottom)
              #text(size: angaben-groesse)[geb. am]\
              #raw-text(geburtsdatum)
            ]
          )
        ],

        [
          #text(size: angaben-groesse)[Versichertennummer]\
          #raw-text(vnummer)
        ],
      )
    ],
    [
      #set text(size: 12pt, weight: "bold")
      Antrag des / der Versicherten auf Kostenerstattung (Psychotherapie) gem. §13 Abs. 3 SGB V\
      #text(size: 9pt, weight: "regular")[Nicht zur Weiterleitung an den Gutachter bestimmt.]
    ],
  )


  #vbox(vbox-content, line-thickness: line-thickness)

  *Ich beantrage Kostenerstattung für die psychotherapeutische Behandlung durch*

  // Angaben des Therapeuten
  #grid(
    columns: (2cm, 1fr),
    rows: 2em,
    row-gutter: 2em,
    align: horizon,
    [Herrn/Frau],
    [
      #box(
        raw-text(size: 9pt)[#therapeut, Arztregister-Nr.: #arztregister-nr],
        width: 100%,
        height: 2.7em,
        inset: (left: 2mm),
        stroke: (paint: black, thickness: line-thickness),
      )
    ],

    [Anschrift],
    [
      #box(
        raw-text(praxisadresse, size: 9pt),
        width: 100%,
        height: 1.6cm,
        inset: (left: 2mm),
        stroke: (paint: black, thickness: line-thickness),
      )
    ],
  )




  // Auswahl der Therapieform
  #v(0.5cm)
  #grid(
    columns: 2,
    column-gutter: 2em,
    row-gutter: 1.5em,
    [#checkbox("ap", checks) Analytische Psychotherapie], [#checkbox("einzel", checks) Einzeltherapie],
    [#checkbox("tp", checks) Tiefenpsychologisch fundierte Therapie], [#checkbox("gruppe", checks) Gruppentherapie],
    [#checkbox("vt", checks) Verhaltenstherapie],
    [#checkbox("kombination", checks) Kombinationsbehandlung Einzel-/Gruppentherapie],
  )

  #v(1fr)

  *Ich beantrage die Psychotherapie als*
  #grid(
    columns: (1fr, 3fr),
    [#checkbox("erstantrag", checks) Erstantrag],
    [#checkbox("folgeantrag", checks) Folgeantrag (während einer laufenden Behandlung)],
  )

  #v(1fr)
  *_Bei Erstanträgen bitte angeben_*

  Waren sie in den letzten 12 Monaten aufgrund einer psychischen Erkrankung in stationärer oder rehabilitativer Behandlung?
  #grid(
    columns: (1fr, 3fr),
    [#checkbox("station-ja", checks) Ja], [#checkbox("station-nein", checks) Nein],
  )

  Wurde vor dem jetzigen Antrag in den letzten 2 Jahren bereits eine ambulante psychotherapeutische Behandlung durchgeführt?
  #grid(
    columns: (1fr, 3fr),
    [#checkbox("ambulant-ja", checks) Ja], [#checkbox("ambulant-nein", checks) Nein],
  )

  #v(1fr)


  #grid(
    columns: (1.6fr, 1fr, 2fr),
    align: right + bottom,
    [],
    [
      #set align(left)
      Ausstellungsdatum
      #v(-3mm)
      #for i in datum-formatiert {
        box(stroke: (thickness: line-thickness), width: 15pt, height: 20pt)[
          #set align(center + horizon)
          #raw-text(i, size: 9pt)
        ]
      }
    ],
    [#box(height: 3cm, width: 8cm, stroke: line-thickness, inset: 2mm)[
        #set align(left + bottom)
        #set text(size: 8pt)
        Unterschrift Patient/Patientin, ggf. der gesetzlichen Vertreter
      ]],
  )

  #v(1fr)

  #set align(center)
  #grid(
    columns: 3,
    column-gutter: 1em,
    [#checkbox("versicherter", ausfertigung) Ausfertigung Versicherte/Versicherter],
    [#checkbox("krankenkasse", ausfertigung) Ausfertigung Krankenkasse],
    [#checkbox("therapeut", ausfertigung) Ausfertigung Therapeut/Therapeutin],
  )
]

#let single-ptv-2(
  krankenkasse: none,
  krankenkasse-adresse: none,
  nachname: none,
  geburtsdatum: none,
  diagnosen: ([], [], []),
  checks: (),
  datum: [],
  einheiten-ebm: [],
  einheiten-gop: [],
  einheiten-ebm-bezugsperson: [],
  einheiten-gop-bezugsperson: [],
  ziffern-ebm: ([], [], []),
  ziffern-gop: ([], [], []),
  ziffern-ebm-bezugsperson: ([], []),
  ziffern-gop-bezugsperson: ([], []),
  bisher-einzel: [],
  bisher-gruppe: [],
  bisher-einzel-ziffern: [],
  bisher-gruppe-ziffern: [],
  stempel: [],
  ausfertigung: (),
  body,
) = [
  #let angaben-groesse = 7pt
  #set text(font: "Roboto", size: 10pt)
  #set page(margin: 1cm)
  #let line-thickness = 0.3pt
  #let vbox-content = [
    #krankenkasse\
    #krankenkasse-adresse
  ]
  #let anfangsbuchstabe = nachname.at("text").first()
  // #let dob-tag = geburtsdatum.at("text").slice(0, count: 2)
  // #let dob-monat = geburtsdatum.at("text").slice(3, count: 2)
  // #let dob-jahr = geburtsdatum.at("text").slice(8, count: 2)
  #let chiffre = anfangsbuchstabe + format-date(geburtsdatum)
  // #let datum-tag = datum.at("text").slice(0, count: 2)
  // #let datum-monat = datum.at("text").slice(3, count: 2)
  // #let datum-jahr = datum.at("text").slice(8, count: 2)
  #let datum-formatiert = format-date(datum)

  #grid(
    columns: 2,
    column-gutter: 0.5cm,
    [
      #vbox(vbox-content, line-thickness: line-thickness)
    ],
    [
      #set text(size: 12pt, weight: "bold")
      Angaben Therapeut/Therapeutin zum Antrag der/des Versicherten zur Psychotherapie in Kostenerstattung gem. §13 Abs. 3 SGB V\

      #set text(size: 9pt, weight: "regular")
      Chiffre Patient/Patientin


      #align(center)[
        #for i in chiffre {
          box(stroke: (paint: black, thickness: line-thickness), width: 15pt, height: 20pt)[
            #set align(center + horizon)
            #set text(font: "DejaVu Sans Mono")
            #i
          ]
        }
      ]

      #v(0.5cm)
      Diagnose(n) (ICD-10-GM endstellig)

      #grid(
        columns: 3 * (1fr,),
        column-gutter: 2.5em,
        ..diagnosen.map(it => [
          #set align(center + horizon)
          #set text(font: "DejaVu Sans Mono")
          #box(it, width: 100%, height: 0.7cm, stroke: (paint: black, thickness: line-thickness))
        ])
      )

      #checkbox("f70", checks) Es liegt eine Diagnose nach F70-F79 (ICD-10-GM) vor.
    ],
  )

  *Psychotherapie*

  #grid(
    columns: 3 * (1fr,),
    [
      #checkbox("erw", checks) Für Erwachsene (Erw)\
      #checkbox("kiju", checks) Für Kinder und Jugendliche (KiJu)
      #line(stroke: (paint: black, thickness: line-thickness), length: 95%)
      #checkbox("ap", checks) Analytische Pschotherapie (AP)\
      #checkbox("tp", checks) Tiefenpsychologisch fundierte\
      #h(20pt) Therapie (TP)\
      #checkbox("vt", checks) Verhaltenstherapie (VT)
    ],
    [
      #checkbox("kzt1", checks) Kurzzeittherapie 1 (KZT 1)\
      #checkbox("kzt2", checks) Kurzzeittherapie 2 (KZT 2)\
      #checkbox("lzt", checks) Langzeittherapie (LZT) als\
      #h(20pt) #checkbox("erstantrag", checks) Erstantrag\
      #h(20pt) #checkbox("umwandlung", checks) Umwandlung\
      #h(20pt) #checkbox("fortführung", checks) Fortführung
    ], [
      #checkbox("einzel", checks) Ausschließlich Einzeltherapie\
      #checkbox("gruppe", checks) Ausschließlich Gruppentherapie\
      #checkbox("kombination", checks) Kombinationsbehandlung mit\
      #h(20pt) #checkbox("kombi-einzel", checks) Überwiegend Einzeltherapie\
      #h(20pt) #checkbox("kombi-gruppe", checks) Überwiegend Gruppentherapie\
      #h(20pt) #checkbox("kombi-zwei", checks) Kombinationsbehandlung\
      #h(40pt) durch zwei Therapeuten/\
      #h(40pt) Therapeutinnen
    ]
  )

  *Für die KZT 1, KZT 2 oder LZT in diesem Bewilligungsabschnitt werden beantragt*

  #number-boxes(einheiten-ebm, 3) #h(0.5em) Therapieeinheiten analog EBM-Ziffer #h(0.5em)
  #box()[
    #grid(
      columns: 3,
      column-gutter: 1em,
      [#number-boxes(ziffern-ebm.at(0), 5) ,],
      [#number-boxes(ziffern-ebm.at(1), 5) ,],
      [#number-boxes(ziffern-ebm.at(2), 5)],
    )
  ]

  #number-boxes(einheiten-gop, 3) #h(0.5em) Therapieeinheiten nach GOP-Ziffer #h(0.5em)
  #box()[
    #grid(
      columns: 3,
      column-gutter: 1em,
      [#number-boxes(ziffern-gop.at(0), 3) ,],
      [#number-boxes(ziffern-gop.at(1), 3) ,],
      [#number-boxes(ziffern-gop.at(2), 3)],
    )
  ]

  *Für den Einbezug von Bezugspersonen in diesem Bewilligungsabschnitt werden beantragt*

  #number-boxes(einheiten-ebm-bezugsperson, 3) #h(0.5em) Therapieeinheiten analog EBM-Ziffer #h(0.5em)
  #box()[
    #grid(
      columns: 3,
      column-gutter: 1em,
      [#number-boxes(ziffern-ebm-bezugsperson.at(0), 5) B,], [#number-boxes(ziffern-ebm-bezugsperson.at(1), 5) B],
    )
  ]

  #number-boxes(einheiten-gop-bezugsperson, 3) #h(0.5em) Therapieeinheiten nach GOP-Ziffer #h(0.5em)
  #box()[
    #grid(
      columns: 3,
      column-gutter: 1em,
      [#number-boxes(ziffern-gop-bezugsperson.at(0), 3)],
    )
  ]

  #v(0.5cm)
  #grid(
    columns: 2,
    align: top,
    [#checkbox("gebührentabelle", checks, nudge: -2pt)],
    [Darüber hinaus werden alle für die Psychotherapie relevanten und erforderlichen Leistungen gemäß beiliegender Gebührentabelle beantragt],
  )


  *Bisheriger Behandlungsumfang*
  #grid(
    columns: (auto, 9cm, auto),
    column-gutter: 1em,
    row-gutter: 1em,
    align: left,
    [#number-boxes(bisher-einzel, 3, nudge: 0pt)],
    [Therapieeinheiten in der KZT1, KZT2 und LZT als Einzelbehandlung analog EBM/GOP-Ziffern:],
    [#box(
        stroke: 0.3pt,
        width: 100%,
        height: 0.8cm,
        outset: 1mm,
        raw-text(bisher-einzel-ziffern, size: 10pt),
      )],

    [#number-boxes(bisher-gruppe, 3, nudge: 0pt)],
    [Therapieeinheiten in der KZT1, KZT2 und LZT als Gruppenbehandlung analog EBM/GOP-Ziffern:],
    [#box(
        stroke: 0.3pt,
        width: 100%,
        height: 0.8cm,
        outset: 1mm,
        raw-text(bisher-gruppe-ziffern, size: 10pt),
      )],
  )


  #v(1fr)

  #grid(
    columns: (2.3fr, 1fr, 2fr),
    align: right + bottom,
    [],
    [
      #set align(left)
      Ausstellungsdatum
      #v(-3mm)
      #for i in datum-formatiert {
        box(stroke: (thickness: line-thickness), width: 15pt, height: 20pt)[
          #set align(center + horizon)
          #raw-text(i, size: 9pt)
        ]
      }
    ],
    [#box(height: 4cm, width: 6.5cm, inset: 1mm, stroke: (paint: black, thickness: line-thickness))[
        #set align(center + horizon)
        #raw-text(stempel, size: 7pt)

        #set align(center + bottom)
        #text(size: 8pt)[Stempel und Unterschrift]
      ]
    ],
  )


  #v(1fr)

  #set align(center)
  #grid(
    columns: 3,
    column-gutter: 1em,
    [#checkbox("krankenkasse", ausfertigung) Ausfertigung Krankenkasse],
    [#checkbox("gutachter", ausfertigung) Ausfertigung Gutachter/Gutachterin],
    [#checkbox("therapeut", ausfertigung) Ausfertigung Therapeut/Therapeutin],
  )
]

#let abtretungserklaerung(
  krankenkasse: none,
  krankenkasse-adresse: none,
  vorname: none,
  nachname: none,
  geburtsdatum: none,
  adresse: none,
  therapeut: none,
  anrede: none,
  datum: [],
  body,
) = [
  #set text(font: "Roboto", size: 11pt)
  #set page(margin: 1cm)
  #set par(justify: true, leading: 1em)
  #let nachname-vorname = [#nachname, #vorname]
  #let line-thickness = 0.3pt
  #let vbox-content = [
    #krankenkasse\
    #krankenkasse-adresse
  ]

  #v(2cm)
  #text(size: 15pt, weight: "bold")[
    #align(center)[Abtretungserklärung und Schweigepflichtsentbindung]
  ]
  #v(1cm)

  #grid(
    columns: (4cm, auto),
    row-gutter: 1em,
    [Hiermit erkläre ich,], [#raw-text(vorname + " " + nachname, size: 10pt),],
    [geboren am], [#raw-text(geburtsdatum, size: 10pt),],
    [wohnhaft in], [#raw-text(adresse, size: 10pt)],
  )

  mein Einverständnis dazu, dass #anrede #therapeut die Kosten für meine ambulante psychotherapeutische Behandlung direkt mit meiner Krankenkasse

  #h(4cm) #box(raw-text(vbox-content, size: 10pt))


  abrechnet.

  Darüber hinaus entbinde ich meine oben genannte Krankenkasse im nachfolgend spezifizierten Umfang von ihrer Schweigepflicht mir gegenüber. Die oben genannte Krankenkasse ist aufgrund dieser Schweigepflichtsentbindung berechtigt, alle mich betreffenden Details in Fragen der Abrechnung zu offenbaren und gegebenenfalls in Kopie herauszugeben.

  #v(2cm)
  #set text(size: 8pt)
  #grid(
    columns: 2,
    column-gutter: 2em,
    row-gutter: 0.5em,
    align: bottom,
    [
      #box(
        width: 6cm,
        stroke: (bottom: (paint: black, thickness: 0.3pt)),
        inset: (bottom: 1mm),
      )[
        #set text(font: "DejaVu Sans Mono", size: 10pt)
        Dortmund, #datum
      ]
    ],
    [#box(width: 9cm, stroke: (bottom: (paint: black, thickness: 0.3pt)))],

    [Ort, Datum], [Unterschrift Patient/Patientin],
  )

]

#let single-ptv8(
  krankenkasse: [],
  krankenkasse-adresse: [],
  nachname: [],
  geburtsdatum: [],
  checks: (),
  datum: [],
  stempel: [],
  body,
) = {
  let anfangsbuchstabe = nachname.at("text").first()
  let dob-formatiert = format-date(geburtsdatum)
  let datum-formatiert = format-date(datum)
  let chiffre = {
    anfangsbuchstabe + dob-formatiert
  }

  set page(paper: "a5", flipped: true, margin: 7mm)
  set text(font: "Roboto")

  grid(
    columns: 2,
    column-gutter: 1cm,
    [
      #box(fill: black, height: 2cm, width: 100%, inset: 2mm)[
        #set text(fill: white, size: 14pt)
        #set align(horizon)
        *_VERTRAULICH\ Nur Gutacher/Gutachterinnen dürfen diesen Umschlag öffnen_*
      ]

      #v(1fr)

      #vbox([#krankenkasse\ #krankenkasse-adresse])

      #v(1fr)

      #set text(size: 8pt)
      *Inhalt*

      #grid(
        columns: 2,
        align: top,
        [#checkbox("test", "test", nudge: 0pt)],
        [Die erforderlichen Unterlagen sind entsprechend der gesetzlichen Vorgaben vollständig enthalten.],
      )

      *Erklärung Therapeut/Therapeutin*

      #grid(
        columns: 2,
        align: top,
        [#checkbox("test", "test", nudge: 0pt)],
        [Ich erkläre, den Bericht entsprechend der gesetzlichen Vorgaben vollständig persönlich verfasst zu haben.],
      )
    ],
    [
      *Unterlagen für das Gutachtenverfahren Psychotherapie in der Kostenerstattung*\
      #set text(size: 8pt)
      (Zutreffendes bitte ankreuzen)

      Chiffre Patient/Patientin #h(3mm)
      #box(
        move(dy: 4pt)[
          #for i in chiffre {
            box(stroke: (paint: black, thickness: 0.3pt), width: 12pt, height: 16pt)[
              #set align(center + horizon)
              #set text(font: "DejaVu Sans Mono", size: 8pt)
              #i
            ]
          }
        ],
      )


      #v(1fr)

      *Begutachtung einer*

      #grid(
        columns: 4,
        column-gutter: 10mm,
        row-gutter: 3mm,
        [#checkbox("ap", checks) AP],
        [#checkbox("st", checks) ST],
        [#checkbox("tp", checks) TP],
        [#checkbox("vt", checks) VT],

        [#checkbox("kiju", checks) KiJu], [#checkbox("erw", checks) Erw],
      )

      #grid(
        columns: 4,
        column-gutter: 10mm,
        [#checkbox("einzel", checks) Einzelbehandlung],
        [
          #set par(hanging-indent: 7mm)
          #checkbox("kombi", checks) Gruppen- / Kombinationsbehandlung],
      )

      *Antragsart*

      #grid(
        columns: 3,
        column-gutter: 10mm,
        row-gutter: 3mm,
        [
          #if "erstantrag" in checks and "lzt" in checks [
            #checkbox("test", "test", nudge: 8pt) LZT\
            #h(7mm) Erstantrag
          ] else [
            #checkbox("no", "test", nudge: 8pt) LZT\
            #h(7mm) Erstantrag
          ]
        ],
        [
          #if "umwandlung" in checks and "lzt" in checks [
            #checkbox("test", "test", nudge: 8pt) LZT\
            #h(7mm) Umwandlung
          ] else [
            #checkbox("no", "test", nudge: 8pt) LZT\
            #h(7mm) Umwandlung
          ]
        ],
        [
          #if "fortführung" in checks and "lzt" in checks [
            #checkbox("test", "test", nudge: 8pt) LZT\
            #h(7mm) Fortführung
          ] else [
            #checkbox("no", "test", nudge: 8pt) LZT\
            #h(7mm) Fortführung
          ]
        ],

        [
          #checkbox("kzt1", checks, nudge: 3pt) KZT 1
        ],
        [
          #checkbox("kzt2", checks, nudge: 3pt) KZT 2
        ],
      )



      #v(1fr)


      #grid(
        columns: (1fr, 2fr),
        align: right + bottom,
        [
          #set align(left)
          Ausstellungsdatum
          #v(-3mm)
          #for i in datum-formatiert {
            box(stroke: (thickness: 0.3pt), width: 12pt, height: 16pt)[
              #set align(center + horizon)
              #raw-text(i, size: 9pt)
            ]
          }
        ],
        [#box(height: 3.5cm, width: 5cm, inset: 1mm, stroke: (paint: black, thickness: 0.3pt))[
            #set align(center + horizon)
            #raw-text(stempel, size: 6pt)

            #set align(center + bottom)
            #text(size: 8pt)[Stempel und Unterschrift]
          ]
        ],
      )
    ],
  )
}

#let ptv(
  therapeut: [],
  anrede: [],
  arztregister-nr: [],
  berufsbezeichnung: [],
  praxisadresse: [],
  stempel: [],
  krankenkasse: none,
  krankenkasse-adresse: none,
  vorname: none,
  nachname: none,
  geburtsdatum: none,
  adresse: none,
  vnummer: hide[vnummer],
  diagnosen: ([], [], []),
  einheiten-ebm: [],
  einheiten-gop: [],
  einheiten-ebm-bezugsperson: [],
  einheiten-gop-bezugsperson: [],
  ziffern-ebm: ([], [], []),
  ziffern-gop: ([], [], []),
  ziffern-ebm-bezugsperson: ([], []),
  ziffern-gop-bezugsperson: ([], []),
  bisher-einzel: [],
  bisher-gruppe: [],
  bisher-einzel-ziffern: [],
  bisher-gruppe-ziffern: [],
  checks: (),
  datum: [],
  body,
) = [
  #briefpapier(
    datum: datum,
    adresse: [
      #krankenkasse\
      #krankenkasse-adresse
    ],
    referenzen: (
      ([Patient/in], [#vorname #nachname]),
      ([Geburtsdatum], [#geburtsdatum]),
      ([Versichertennummer], [#vnummer]),
    ),
    absender-gruss: [
      #therapeut\
      #text(size: 9pt)[#berufsbezeichnung]
    ],
    body,
  )
  #single-ptv-1(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    vorname: vorname,
    nachname: nachname,
    therapeut: therapeut,
    arztregister-nr: arztregister-nr,
    praxisadresse: praxisadresse,
    geburtsdatum: geburtsdatum,
    adresse: adresse,
    vnummer: vnummer,
    checks: checks,
    datum: datum,
    ausfertigung: "versicherter",
    body,
  )
  #single-ptv-1(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    vorname: vorname,
    nachname: nachname,
    therapeut: therapeut,
    arztregister-nr: arztregister-nr,
    praxisadresse: praxisadresse,
    geburtsdatum: geburtsdatum,
    adresse: adresse,
    vnummer: vnummer,
    checks: checks,
    datum: datum,
    ausfertigung: "krankenkasse",
    body,
  )
  #single-ptv-1(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    vorname: vorname,
    nachname: nachname,
    therapeut: therapeut,
    arztregister-nr: arztregister-nr,
    praxisadresse: praxisadresse,
    geburtsdatum: geburtsdatum,
    adresse: adresse,
    vnummer: vnummer,
    checks: checks,
    datum: datum,
    ausfertigung: "therapeut",
    body,
  )
  #single-ptv-2(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    nachname: nachname,
    geburtsdatum: geburtsdatum,
    diagnosen: diagnosen,
    checks: checks,
    einheiten-ebm: einheiten-ebm,
    einheiten-gop: einheiten-gop,
    einheiten-ebm-bezugsperson: einheiten-ebm-bezugsperson,
    einheiten-gop-bezugsperson: einheiten-gop-bezugsperson,
    ziffern-ebm: ziffern-ebm,
    ziffern-gop: ziffern-gop,
    ziffern-ebm-bezugsperson: ziffern-ebm-bezugsperson,
    ziffern-gop-bezugsperson: ziffern-gop-bezugsperson,
    bisher-einzel: bisher-einzel,
    bisher-gruppe: bisher-gruppe,
    bisher-einzel-ziffern: bisher-einzel-ziffern,
    bisher-gruppe-ziffern: bisher-gruppe-ziffern,
    datum: datum,
    stempel: stempel,
    ausfertigung: "krankenkasse",
    body,
  )
  #single-ptv-2(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    nachname: nachname,
    geburtsdatum: geburtsdatum,
    diagnosen: diagnosen,
    checks: checks,
    einheiten-ebm: einheiten-ebm,
    einheiten-gop: einheiten-gop,
    einheiten-ebm-bezugsperson: einheiten-ebm-bezugsperson,
    einheiten-gop-bezugsperson: einheiten-gop-bezugsperson,
    ziffern-ebm: ziffern-ebm,
    ziffern-gop: ziffern-gop,
    ziffern-ebm-bezugsperson: ziffern-ebm-bezugsperson,
    ziffern-gop-bezugsperson: ziffern-gop-bezugsperson,
    bisher-einzel: bisher-einzel,
    bisher-gruppe: bisher-gruppe,
    bisher-einzel-ziffern: bisher-einzel-ziffern,
    bisher-gruppe-ziffern: bisher-gruppe-ziffern,
    datum: datum,
    stempel: stempel,
    ausfertigung: "gutachter",
    body,
  )
  #single-ptv-2(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    nachname: nachname,
    geburtsdatum: geburtsdatum,
    diagnosen: diagnosen,
    checks: checks,
    einheiten-ebm: einheiten-ebm,
    einheiten-gop: einheiten-gop,
    einheiten-ebm-bezugsperson: einheiten-ebm-bezugsperson,
    einheiten-gop-bezugsperson: einheiten-gop-bezugsperson,
    ziffern-ebm: ziffern-ebm,
    ziffern-gop: ziffern-gop,
    ziffern-ebm-bezugsperson: ziffern-ebm-bezugsperson,
    ziffern-gop-bezugsperson: ziffern-gop-bezugsperson,
    bisher-einzel: bisher-einzel,
    bisher-gruppe: bisher-gruppe,
    bisher-einzel-ziffern: bisher-einzel-ziffern,
    bisher-gruppe-ziffern: bisher-gruppe-ziffern,
    datum: datum,
    stempel: stempel,
    ausfertigung: "therapeut",
    body,
  )
  #abtretungserklaerung(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    vorname: vorname,
    nachname: nachname,
    geburtsdatum: geburtsdatum,
    adresse: adresse,
    therapeut: therapeut,
    anrede: anrede,
    datum: datum,
    body,
  )
  #single-ptv8(
    krankenkasse: krankenkasse,
    krankenkasse-adresse: krankenkasse-adresse,
    nachname: nachname,
    geburtsdatum: geburtsdatum,
    checks: checks,
    datum: datum,
    stempel: stempel,
    body,
  )
]

