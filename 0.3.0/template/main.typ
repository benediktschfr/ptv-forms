#import "@local/ptv-forms:0.2.0": *
#import "config.typ": *

#show: ptv.with(
  therapeut: therapeut,
  anrede: anrede,
  arztregister-nr: arztregister-nr,
  berufsbezeichnung: berufsbezeichnung,
  praxisadresse: praxisadresse,
  stempel: stempel,

  
  krankenkasse: [Musterkrankenkasse],
  krankenkasse-adresse: [
    Krankenkassenstr. 1\
    12345 Krankenkassenstadt
  ],
  vorname: [Horst],
  nachname: [Grabowski],
  adresse: [
    Patientenstr. 27\
    45678 Patientenstadt
  ],
  geburtsdatum: [01.04.1956],
  vnummer: [K123456789],
  datum: [01.04.2025],
  diagnosen: ([F32.0], [], []),
  checks: ("vt", "einzel", "erstantrag", "erw", "lzt"),
  // einheiten-ebm: [60],
  einheiten-gop: [60],
  // ziffern-ebm: ([], [], []),
  ziffern-gop: ([870], [], []),
  // bisher-einzel: [60],
  // bisher-einzel-ziffern: [35425],
)

Sehr geehrte Damen und Herren,

hiermit beantrage ich die außervertragliche Psychotherapie für Ihre oben genannte Versicherte.

Bei Rückfragen stehe ich Ihnen gerne unter der angegebenen Rufnummer zur Verfügung.

Mit freundlichen Grüßen