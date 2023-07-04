/// SMuFL (Standard Music Font Layout) glyphs.
///
/// This enum contains a list of glyphs used in music notation as defined
/// by the SMuFL specification.
enum SmuflGlyph {
  /// 4-string tab clef.
  g4stringTabClef("U+E06E", null, "4-string tab clef"),

  /// 6-string tab clef.
  g6stringTabClef("U+E06D", null, "6-string tab clef"),

  /// 11 large diesis down, 3° down [46 EDO].
  accSagittal11LargeDiesisDown(
      "U+E30D", null, "11 large diesis down, 3° down [46 EDO]"),

  /// 11 large diesis up, (11L), (sharp less 11M), 3° up [46 EDO].
  accSagittal11LargeDiesisUp("U+E30C", null,
      "11 large diesis up, (11L), (sharp less 11M), 3° up [46 EDO]"),

  /// 11 medium diesis down, 1°[17 31] 2°46 down, 1/4-tone down.
  accSagittal11MediumDiesisDown("U+E30B", null,
      "11 medium diesis down, 1°[17 31] 2°46 down, 1/4-tone down"),

  /// 11 medium diesis up, (11M), 1°[17 31] 2°46 up, 1/4-tone up.
  accSagittal11MediumDiesisUp("U+E30A", null,
      "11 medium diesis up, (11M), 1°[17 31] 2°46 up, 1/4-tone up"),

  /// 11:19 large diesis down.
  accSagittal11v19LargeDiesisDown("U+E3AB", null, "11:19 large diesis down"),

  /// 11:19 large diesis up, (11:19L, apotome less 11:19M).
  accSagittal11v19LargeDiesisUp(
      "U+E3AA", null, "11:19 large diesis up, (11:19L, apotome less 11:19M)"),

  /// 11:19 medium diesis down.
  accSagittal11v19MediumDiesisDown("U+E3A3", null, "11:19 medium diesis down"),

  /// 11:19 medium diesis up, (11:19M, 11M plus 19s).
  accSagittal11v19MediumDiesisUp(
      "U+E3A2", null, "11:19 medium diesis up, (11:19M, 11M plus 19s)"),

  /// 11:49 comma down.
  accSagittal11v49CommaDown("U+E397", null, "11:49 comma down"),

  /// 11:49 comma up, (11:49C, 11M less 49C).
  accSagittal11v49CommaUp(
      "U+E396", null, "11:49 comma up, (11:49C, 11M less 49C)"),

  /// 143 comma down.
  accSagittal143CommaDown("U+E395", null, "143 comma down"),

  /// 143 comma up, (143C, 13L less 11M).
  accSagittal143CommaUp("U+E394", null, "143 comma up, (143C, 13L less 11M)"),

  /// 17 comma down.
  accSagittal17CommaDown("U+E343", null, "17 comma down"),

  /// 17 comma up, (17C).
  accSagittal17CommaUp("U+E342", null, "17 comma up, (17C)"),

  /// 17 kleisma down.
  accSagittal17KleismaDown("U+E393", null, "17 kleisma down"),

  /// 17 kleisma up, (17k).
  accSagittal17KleismaUp("U+E392", null, "17 kleisma up, (17k)"),

  /// 19 comma down.
  accSagittal19CommaDown("U+E399", null, "19 comma down"),

  /// 19 comma up, (19C).
  accSagittal19CommaUp("U+E398", null, "19 comma up, (19C)"),

  /// 19 schisma down.
  accSagittal19SchismaDown("U+E391", null, "19 schisma down"),

  /// 19 schisma up, (19s).
  accSagittal19SchismaUp("U+E390", null, "19 schisma up, (19s)"),

  /// 1 mina down, 1/(5⋅7⋅13)-schismina down, 0.42 cents down.
  accSagittal1MinaDown("U+E3F5", null,
      "1 mina down, 1/(5⋅7⋅13)-schismina down, 0.42 cents down"),

  /// 1 mina up, 1/(5⋅7⋅13)-schismina up, 0.42 cents up.
  accSagittal1MinaUp(
      "U+E3F4", null, "1 mina up, 1/(5⋅7⋅13)-schismina up, 0.42 cents up"),

  /// 1 tina down, 7²⋅11⋅19/5-schismina down, 0.17 cents down.
  accSagittal1TinaDown("U+E3F9", null,
      "1 tina down, 7²⋅11⋅19/5-schismina down, 0.17 cents down"),

  /// 1 tina up, 7²⋅11⋅19/5-schismina up, 0.17 cents up.
  accSagittal1TinaUp(
      "U+E3F8", null, "1 tina up, 7²⋅11⋅19/5-schismina up, 0.17 cents up"),

  /// 23 comma down, 2° down [96 EDO], 1/8-tone down.
  accSagittal23CommaDown(
      "U+E371", null, "23 comma down, 2° down [96 EDO], 1/8-tone down"),

  /// 23 comma up, (23C), 2° up [96 EDO], 1/8-tone up.
  accSagittal23CommaUp(
      "U+E370", null, "23 comma up, (23C), 2° up [96 EDO], 1/8-tone up"),

  /// 23 small diesis down.
  accSagittal23SmallDiesisDown("U+E39F", null, "23 small diesis down"),

  /// 23 small diesis up, (23S).
  accSagittal23SmallDiesisUp("U+E39E", null, "23 small diesis up, (23S)"),

  /// 25 small diesis down, 2° down [53 EDO].
  accSagittal25SmallDiesisDown(
      "U+E307", null, "25 small diesis down, 2° down [53 EDO]"),

  /// 25 small diesis up, (25S, ~5:13S, ~37S, 5C plus 5C), 2° up [53 EDO].
  accSagittal25SmallDiesisUp("U+E306", null,
      "25 small diesis up, (25S, ~5:13S, ~37S, 5C plus 5C), 2° up [53 EDO]"),

  /// 2 minas down, 65/77-schismina down, 0.83 cents down.
  accSagittal2MinasDown(
      "U+E3F7", null, "2 minas down, 65/77-schismina down, 0.83 cents down"),

  /// 2 minas up, 65/77-schismina up, 0.83 cents up.
  accSagittal2MinasUp(
      "U+E3F6", null, "2 minas up, 65/77-schismina up, 0.83 cents up"),

  /// 2 tinas down, 1/(7³⋅17)-schismina down, 0.30 cents down.
  accSagittal2TinasDown("U+E3FB", null,
      "2 tinas down, 1/(7³⋅17)-schismina down, 0.30 cents down"),

  /// 2 tinas up, 1/(7³⋅17)-schismina up, 0.30 cents up.
  accSagittal2TinasUp(
      "U+E3FA", null, "2 tinas up, 1/(7³⋅17)-schismina up, 0.30 cents up"),

  /// 35 large diesis down, 2° down [50 EDO], 5/18-tone down.
  accSagittal35LargeDiesisDown(
      "U+E30F", null, "35 large diesis down, 2° down [50 EDO], 5/18-tone down"),

  /// 35 large diesis up, (35L, ~13L, ~125L, sharp less 35M), 2°50 up.
  accSagittal35LargeDiesisUp("U+E30E", null,
      "35 large diesis up, (35L, ~13L, ~125L, sharp less 35M), 2°50 up"),

  /// 35 medium diesis down, 1°[50] 2°[27] down, 2/9-tone down.
  accSagittal35MediumDiesisDown("U+E309", null,
      "35 medium diesis down, 1°[50] 2°[27] down, 2/9-tone down"),

  /// 35 medium diesis up, (35M, ~13M, ~125M, 5C plus 7C), 2/9-tone up.
  accSagittal35MediumDiesisUp("U+E308", null,
      "35 medium diesis up, (35M, ~13M, ~125M, 5C plus 7C), 2/9-tone up"),

  /// 3 tinas down, 1 mina down, 1/(5⋅7⋅13)-schismina down, 0.42 cents down.
  accSagittal3TinasDown("U+E3FD", null,
      "3 tinas down, 1 mina down, 1/(5⋅7⋅13)-schismina down, 0.42 cents down"),

  /// 3 tinas up, 1 mina up, 1/(5⋅7⋅13)-schismina up, 0.42 cents up.
  accSagittal3TinasUp("U+E3FC", null,
      "3 tinas up, 1 mina up, 1/(5⋅7⋅13)-schismina up, 0.42 cents up"),

  /// 49 large diesis down.
  accSagittal49LargeDiesisDown("U+E3A9", null, "49 large diesis down"),

  /// 49 large diesis up, (49L, ~31L, apotome less 49M).
  accSagittal49LargeDiesisUp(
      "U+E3A8", null, "49 large diesis up, (49L, ~31L, apotome less 49M)"),

  /// 49 medium diesis down.
  accSagittal49MediumDiesisDown("U+E3A5", null, "49 medium diesis down"),

  /// 49 medium diesis up, (49M, ~31M, 7C plus 7C).
  accSagittal49MediumDiesisUp(
      "U+E3A4", null, "49 medium diesis up, (49M, ~31M, 7C plus 7C)"),

  /// 49 small diesis down.
  accSagittal49SmallDiesisDown("U+E39D", null, "49 small diesis down"),

  /// 49 small diesis up, (49S, ~31S).
  accSagittal49SmallDiesisUp("U+E39C", null, "49 small diesis up, (49S, ~31S)"),

  /// 4 tinas down, 5²⋅11²/7-schismina down, 0.57 cents down.
  accSagittal4TinasDown(
      "U+E3FF", null, "4 tinas down, 5²⋅11²/7-schismina down, 0.57 cents down"),

  /// 4 tinas up, 5²⋅11²/7-schismina up, 0.57 cents up.
  accSagittal4TinasUp(
      "U+E3FE", null, "4 tinas up, 5²⋅11²/7-schismina up, 0.57 cents up"),

  /// 55 comma down, 3° down [96 EDO], 3/16-tone down.
  accSagittal55CommaDown(
      "U+E345", null, "55 comma down, 3° down [96 EDO], 3/16-tone down"),

  /// 55 comma up, (55C, 11M less 5C), 3°up [96 EDO], 3/16-tone up.
  accSagittal55CommaUp("U+E344", null,
      "55 comma up, (55C, 11M less 5C), 3°up [96 EDO], 3/16-tone up"),

  /// 5 comma down, 1° down [22 27 29 34 41 46 53 96 EDOs], 1/12-tone down.
  accSagittal5CommaDown("U+E303", null,
      "5 comma down, 1° down [22 27 29 34 41 46 53 96 EDOs], 1/12-tone down"),

  /// 5 comma up, (5C), 1° up [22 27 29 34 41 46 53 96 EDOs], 1/12-tone up.
  accSagittal5CommaUp("U+E302", null,
      "5 comma up, (5C), 1° up [22 27 29 34 41 46 53 96 EDOs], 1/12-tone up"),

  /// 5 tinas down, 7⁴/25-schismina down, 0.72 cents down.
  accSagittal5TinasDown(
      "U+E401", null, "5 tinas down, 7⁴/25-schismina down, 0.72 cents down"),

  /// 5 tinas up, 7⁴/25-schismina up, 0.72 cents up.
  accSagittal5TinasUp(
      "U+E400", null, "5 tinas up, 7⁴/25-schismina up, 0.72 cents up"),

  /// 5:11 small diesis down.
  accSagittal5v11SmallDiesisDown("U+E349", null, "5:11 small diesis down"),

  /// 5:11 small diesis up, (5:11S, ~7:13S, ~11:17S, 5:7k plus 7:11C).
  accSagittal5v11SmallDiesisUp("U+E348", null,
      "5:11 small diesis up, (5:11S, ~7:13S, ~11:17S, 5:7k plus 7:11C)"),

  /// 5:13 large diesis down.
  accSagittal5v13LargeDiesisDown("U+E3AD", null, "5:13 large diesis down"),

  /// 5:13 large diesis up, (5:13L, ~37L, apotome less 5:13M).
  accSagittal5v13LargeDiesisUp("U+E3AC", null,
      "5:13 large diesis up, (5:13L, ~37L, apotome less 5:13M)"),

  /// 5:13 medium diesis down.
  accSagittal5v13MediumDiesisDown("U+E3A1", null, "5:13 medium diesis down"),

  /// 5:13 medium diesis up, (5:13M, ~37M, 5C plus 13C).
  accSagittal5v13MediumDiesisUp(
      "U+E3A0", null, "5:13 medium diesis up, (5:13M, ~37M, 5C plus 13C)"),

  /// 5:19 comma down, 1/20-tone down.
  accSagittal5v19CommaDown("U+E373", null, "5:19 comma down, 1/20-tone down"),

  /// 5:19 comma up, (5:19C, 5C plus 19s), 1/20-tone up.
  accSagittal5v19CommaUp(
      "U+E372", null, "5:19 comma up, (5:19C, 5C plus 19s), 1/20-tone up"),

  /// 5:23 small diesis down, 2° down [60 EDO], 1/5-tone down.
  accSagittal5v23SmallDiesisDown("U+E375", null,
      "5:23 small diesis down, 2° down [60 EDO], 1/5-tone down"),

  /// 5:23 small diesis up, (5:23S, 5C plus 23C), 2° up [60 EDO], 1/5-tone up.
  accSagittal5v23SmallDiesisUp("U+E374", null,
      "5:23 small diesis up, (5:23S, 5C plus 23C), 2° up [60 EDO], 1/5-tone up"),

  /// 5:49 medium diesis down.
  accSagittal5v49MediumDiesisDown("U+E3A7", null, "5:49 medium diesis down"),

  /// 5:49 medium diesis up, (5:49M, half apotome).
  accSagittal5v49MediumDiesisUp(
      "U+E3A6", null, "5:49 medium diesis up, (5:49M, half apotome)"),

  /// 5:7 kleisma down.
  accSagittal5v7KleismaDown("U+E301", null, "5:7 kleisma down"),

  /// 5:7 kleisma up, (5:7k, ~11:13k, 7C less 5C).
  accSagittal5v7KleismaUp(
      "U+E300", null, "5:7 kleisma up, (5:7k, ~11:13k, 7C less 5C)"),

  /// 6 tinas down, 2 minas down, 65/77-schismina down, 0.83 cents down.
  accSagittal6TinasDown("U+E403", null,
      "6 tinas down, 2 minas down, 65/77-schismina down, 0.83 cents down"),

  /// 6 tinas up, 2 minas up, 65/77-schismina up, 0.83 cents up.
  accSagittal6TinasUp("U+E402", null,
      "6 tinas up, 2 minas up, 65/77-schismina up, 0.83 cents up"),

  /// 7 comma down, 1° down [43 EDO], 2° down [72 EDO], 1/6-tone down.
  accSagittal7CommaDown("U+E305", null,
      "7 comma down, 1° down [43 EDO], 2° down [72 EDO], 1/6-tone down"),

  /// 7 comma up, (7C), 1° up [43 EDO], 2° up [72 EDO], 1/6-tone up.
  accSagittal7CommaUp("U+E304", null,
      "7 comma up, (7C), 1° up [43 EDO], 2° up [72 EDO], 1/6-tone up"),

  /// 7 tinas down, 7/(5²⋅17)-schismina down, 1.02 cents down.
  accSagittal7TinasDown("U+E405", null,
      "7 tinas down, 7/(5²⋅17)-schismina down, 1.02 cents down"),

  /// 7 tinas up, 7/(5²⋅17)-schismina up, 1.02 cents up.
  accSagittal7TinasUp(
      "U+E404", null, "7 tinas up, 7/(5²⋅17)-schismina up, 1.02 cents up"),

  /// 7:11 comma down, 1° down [60 EDO], 1/10-tone down.
  accSagittal7v11CommaDown(
      "U+E347", null, "7:11 comma down, 1° down [60 EDO], 1/10-tone down"),

  /// 7:11 comma up, (7:11C, ~13:17S, ~29S, 11L less 7C), 1° up [60 EDO].
  accSagittal7v11CommaUp("U+E346", null,
      "7:11 comma up, (7:11C, ~13:17S, ~29S, 11L less 7C), 1° up [60 EDO]"),

  /// 7:11 kleisma down.
  accSagittal7v11KleismaDown("U+E341", null, "7:11 kleisma down"),

  /// 7:11 kleisma up, (7:11k, ~29k).
  accSagittal7v11KleismaUp("U+E340", null, "7:11 kleisma up, (7:11k, ~29k)"),

  /// 7:19 comma down.
  accSagittal7v19CommaDown("U+E39B", null, "7:19 comma down"),

  /// 7:19 comma up, (7:19C, 7C less 19s).
  accSagittal7v19CommaUp("U+E39A", null, "7:19 comma up, (7:19C, 7C less 19s)"),

  /// 8 tinas down, 11⋅17/(5²⋅7)-schismina down, 1.14 cents down.
  accSagittal8TinasDown("U+E407", null,
      "8 tinas down, 11⋅17/(5²⋅7)-schismina down, 1.14 cents down"),

  /// 8 tinas up, 11⋅17/(5²⋅7)-schismina up, 1.14 cents up.
  accSagittal8TinasUp(
      "U+E406", null, "8 tinas up, 11⋅17/(5²⋅7)-schismina up, 1.14 cents up"),

  /// 9 tinas down, 1/(7²⋅11)-schismina down, 1.26 cents down.
  accSagittal9TinasDown("U+E409", null,
      "9 tinas down, 1/(7²⋅11)-schismina down, 1.26 cents down"),

  /// 9 tinas up, 1/(7²⋅11)-schismina up, 1.26 cents up.
  accSagittal9TinasUp(
      "U+E408", null, "9 tinas up, 1/(7²⋅11)-schismina up, 1.26 cents up"),

  /// Acute, 5 schisma up (5s), 2 cents up.
  accSagittalAcute("U+E3F2", null, "Acute, 5 schisma up (5s), 2 cents up"),

  /// Double flat, (2 apotomes down)[almost all EDOs], whole-tone down.
  accSagittalDoubleFlat("U+E335", null,
      "Double flat, (2 apotomes down)[almost all EDOs], whole-tone down"),

  /// Double flat 11:49C-up.
  accSagittalDoubleFlat11v49CUp("U+E3E9", null, "Double flat 11:49C-up"),

  /// Double flat 143C-up.
  accSagittalDoubleFlat143CUp("U+E3EB", null, "Double flat 143C-up"),

  /// Double flat 17C-up.
  accSagittalDoubleFlat17CUp("U+E365", null, "Double flat 17C-up"),

  /// Double flat 17k-up.
  accSagittalDoubleFlat17kUp("U+E3ED", null, "Double flat 17k-up"),

  /// Double flat 19C-up.
  accSagittalDoubleFlat19CUp("U+E3E7", null, "Double flat 19C-up"),

  /// Double flat 19s-up.
  accSagittalDoubleFlat19sUp("U+E3EF", null, "Double flat 19s-up"),

  /// Double flat 23C-up, 14° down [96 EDO], 7/8-tone down.
  accSagittalDoubleFlat23CUp(
      "U+E387", null, "Double flat 23C-up, 14° down [96 EDO], 7/8-tone down"),

  /// Double flat 23S-up.
  accSagittalDoubleFlat23SUp("U+E3E1", null, "Double flat 23S-up"),

  /// Double flat 25S-up, 8°down [53 EDO].
  accSagittalDoubleFlat25SUp(
      "U+E32D", null, "Double flat 25S-up, 8°down [53 EDO]"),

  /// Double flat 49S-up.
  accSagittalDoubleFlat49SUp("U+E3E3", null, "Double flat 49S-up"),

  /// Double flat 55C-up, 13° down [96 EDO], 13/16-tone down.
  accSagittalDoubleFlat55CUp(
      "U+E363", null, "Double flat 55C-up, 13° down [96 EDO], 13/16-tone down"),

  /// Double flat 5C-up, 5°[22 29] 7°[34 41] 9°53 down, 11/12 tone down.
  accSagittalDoubleFlat5CUp("U+E331", null,
      "Double flat 5C-up, 5°[22 29] 7°[34 41] 9°53 down, 11/12 tone down"),

  /// Double flat 5:11S-up.
  accSagittalDoubleFlat5v11SUp("U+E35F", null, "Double flat 5:11S-up"),

  /// Double flat 5:19C-up, 19/20-tone down.
  accSagittalDoubleFlat5v19CUp(
      "U+E385", null, "Double flat 5:19C-up, 19/20-tone down"),

  /// Double flat 5:23S-up, 8° down [60 EDO], 4/5-tone down.
  accSagittalDoubleFlat5v23SUp(
      "U+E383", null, "Double flat 5:23S-up, 8° down [60 EDO], 4/5-tone down"),

  /// Double flat 5:7k-up.
  accSagittalDoubleFlat5v7kUp("U+E333", null, "Double flat 5:7k-up"),

  /// Double flat 7C-up, 5° down [43 EDO], 10° down [72 EDO], 5/6-tone down.
  accSagittalDoubleFlat7CUp("U+E32F", null,
      "Double flat 7C-up, 5° down [43 EDO], 10° down [72 EDO], 5/6-tone down"),

  /// Double flat 7:11C-up, 9° down [60 EDO], 9/10-tone down.
  accSagittalDoubleFlat7v11CUp(
      "U+E361", null, "Double flat 7:11C-up, 9° down [60 EDO], 9/10-tone down"),

  /// Double flat 7:11k-up.
  accSagittalDoubleFlat7v11kUp("U+E367", null, "Double flat 7:11k-up"),

  /// Double flat 7:19C-up.
  accSagittalDoubleFlat7v19CUp("U+E3E5", null, "Double flat 7:19C-up"),

  /// Double sharp, (2 apotomes up)[almost all EDOs], whole-tone up.
  accSagittalDoubleSharp("U+E334", null,
      "Double sharp, (2 apotomes up)[almost all EDOs], whole-tone up"),

  /// Double sharp 11:49C-down.
  accSagittalDoubleSharp11v49CDown("U+E3E8", null, "Double sharp 11:49C-down"),

  /// Double sharp 143C-down.
  accSagittalDoubleSharp143CDown("U+E3EA", null, "Double sharp 143C-down"),

  /// Double sharp 17C-down.
  accSagittalDoubleSharp17CDown("U+E364", null, "Double sharp 17C-down"),

  /// Double sharp 17k-down.
  accSagittalDoubleSharp17kDown("U+E3EC", null, "Double sharp 17k-down"),

  /// Double sharp 19C-down.
  accSagittalDoubleSharp19CDown("U+E3E6", null, "Double sharp 19C-down"),

  /// Double sharp 19s-down.
  accSagittalDoubleSharp19sDown("U+E3EE", null, "Double sharp 19s-down"),

  /// Double sharp 23C-down, 14°up [96 EDO], 7/8-tone up.
  accSagittalDoubleSharp23CDown(
      "U+E386", null, "Double sharp 23C-down, 14°up [96 EDO], 7/8-tone up"),

  /// Double sharp 23S-down.
  accSagittalDoubleSharp23SDown("U+E3E0", null, "Double sharp 23S-down"),

  /// Double sharp 25S-down, 8°up [53 EDO].
  accSagittalDoubleSharp25SDown(
      "U+E32C", null, "Double sharp 25S-down, 8°up [53 EDO]"),

  /// Double sharp 49S-down.
  accSagittalDoubleSharp49SDown("U+E3E2", null, "Double sharp 49S-down"),

  /// Double sharp 55C-down, 13° up [96 EDO], 13/16-tone up.
  accSagittalDoubleSharp55CDown(
      "U+E362", null, "Double sharp 55C-down, 13° up [96 EDO], 13/16-tone up"),

  /// Double sharp 5C-down, 5°[22 29] 7°[34 41] 9°53 up, 11/12 tone up.
  accSagittalDoubleSharp5CDown("U+E330", null,
      "Double sharp 5C-down, 5°[22 29] 7°[34 41] 9°53 up, 11/12 tone up"),

  /// Double sharp 5:11S-down.
  accSagittalDoubleSharp5v11SDown("U+E35E", null, "Double sharp 5:11S-down"),

  /// Double sharp 5:19C-down, 19/20-tone up.
  accSagittalDoubleSharp5v19CDown(
      "U+E384", null, "Double sharp 5:19C-down, 19/20-tone up"),

  /// Double sharp 5:23S-down, 8° up [60 EDO], 4/5-tone up.
  accSagittalDoubleSharp5v23SDown(
      "U+E382", null, "Double sharp 5:23S-down, 8° up [60 EDO], 4/5-tone up"),

  /// Double sharp 5:7k-down.
  accSagittalDoubleSharp5v7kDown("U+E332", null, "Double sharp 5:7k-down"),

  /// Double sharp 7C-down, 5°[43] 10°[72] up, 5/6-tone up.
  accSagittalDoubleSharp7CDown(
      "U+E32E", null, "Double sharp 7C-down, 5°[43] 10°[72] up, 5/6-tone up"),

  /// Double sharp 7:11C-down, 9° up [60 EDO], 9/10-tone up.
  accSagittalDoubleSharp7v11CDown(
      "U+E360", null, "Double sharp 7:11C-down, 9° up [60 EDO], 9/10-tone up"),

  /// Double sharp 7:11k-down.
  accSagittalDoubleSharp7v11kDown("U+E366", null, "Double sharp 7:11k-down"),

  /// Double sharp 7:19C-down.
  accSagittalDoubleSharp7v19CDown("U+E3E4", null, "Double sharp 7:19C-down"),

  /// Flat, (apotome down)[almost all EDOs], 1/2-tone down.
  accSagittalFlat(
      "U+E319", null, "Flat, (apotome down)[almost all EDOs], 1/2-tone down"),

  /// Flat 11L-down, 8° up [46 EDO].
  accSagittalFlat11LDown("U+E329", null, "Flat 11L-down, 8° up [46 EDO]"),

  /// Flat 11M-down, 3° down [17 31 EDOs], 7° down [46 EDO], 3/4-tone down.
  accSagittalFlat11MDown("U+E327", null,
      "Flat 11M-down, 3° down [17 31 EDOs], 7° down [46 EDO], 3/4-tone down"),

  /// Flat 11:19L-down.
  accSagittalFlat11v19LDown("U+E3DB", null, "Flat 11:19L-down"),

  /// Flat 11:19M-down.
  accSagittalFlat11v19MDown("U+E3D3", null, "Flat 11:19M-down"),

  /// Flat 11:49C-down.
  accSagittalFlat11v49CDown("U+E3C7", null, "Flat 11:49C-down"),

  /// Flat 11:49C-up.
  accSagittalFlat11v49CUp("U+E3B9", null, "Flat 11:49C-up"),

  /// Flat 143C-down.
  accSagittalFlat143CDown("U+E3C5", null, "Flat 143C-down"),

  /// Flat 143C-up.
  accSagittalFlat143CUp("U+E3BB", null, "Flat 143C-up"),

  /// Flat 17C-down.
  accSagittalFlat17CDown("U+E357", null, "Flat 17C-down"),

  /// Flat 17C-up.
  accSagittalFlat17CUp("U+E351", null, "Flat 17C-up"),

  /// Flat 17k-down.
  accSagittalFlat17kDown("U+E3C3", null, "Flat 17k-down"),

  /// Flat 17k-up.
  accSagittalFlat17kUp("U+E3BD", null, "Flat 17k-up"),

  /// Flat 19C-down.
  accSagittalFlat19CDown("U+E3C9", null, "Flat 19C-down"),

  /// Flat 19C-up.
  accSagittalFlat19CUp("U+E3B7", null, "Flat 19C-up"),

  /// Flat 19s-down.
  accSagittalFlat19sDown("U+E3C1", null, "Flat 19s-down"),

  /// Flat 19s-up.
  accSagittalFlat19sUp("U+E3BF", null, "Flat 19s-up"),

  /// Flat 23C-down, 10° down [96 EDO], 5/8-tone down.
  accSagittalFlat23CDown(
      "U+E37D", null, "Flat 23C-down, 10° down [96 EDO], 5/8-tone down"),

  /// Flat 23C-up, 6° down [96 EDO], 3/8-tone down.
  accSagittalFlat23CUp(
      "U+E37B", null, "Flat 23C-up, 6° down [96 EDO], 3/8-tone down"),

  /// Flat 23S-down.
  accSagittalFlat23SDown("U+E3CF", null, "Flat 23S-down"),

  /// Flat 23S-up.
  accSagittalFlat23SUp("U+E3B1", null, "Flat 23S-up"),

  /// Flat 25S-down, 7° down [53 EDO].
  accSagittalFlat25SDown("U+E323", null, "Flat 25S-down, 7° down [53 EDO]"),

  /// Flat 25S-up, 3° down [53 EDO].
  accSagittalFlat25SUp("U+E311", null, "Flat 25S-up, 3° down [53 EDO]"),

  /// Flat 35L-down, 5° down [50 EDO].
  accSagittalFlat35LDown("U+E32B", null, "Flat 35L-down, 5° down [50 EDO]"),

  /// Flat 35M-down, 4° down [50 EDO], 6° down [27 EDO], 13/18-tone down.
  accSagittalFlat35MDown("U+E325", null,
      "Flat 35M-down, 4° down [50 EDO], 6° down [27 EDO], 13/18-tone down"),

  /// Flat 49L-down.
  accSagittalFlat49LDown("U+E3D9", null, "Flat 49L-down"),

  /// Flat 49M-down.
  accSagittalFlat49MDown("U+E3D5", null, "Flat 49M-down"),

  /// Flat 49S-down.
  accSagittalFlat49SDown("U+E3CD", null, "Flat 49S-down"),

  /// Flat 49S-up.
  accSagittalFlat49SUp("U+E3B3", null, "Flat 49S-up"),

  /// Flat 55C-down, 11° down [96 EDO], 11/16-tone down.
  accSagittalFlat55CDown(
      "U+E359", null, "Flat 55C-down, 11° down [96 EDO], 11/16-tone down"),

  /// Flat 55C-up, 5° down [96 EDO], 5/16-tone down.
  accSagittalFlat55CUp(
      "U+E34F", null, "Flat 55C-up, 5° down [96 EDO], 5/16-tone down"),

  /// Flat 5C-down, 4°[22 29] 5°[27 34 41] 6°[39 46 53] down, 7/12-tone down.
  accSagittalFlat5CDown("U+E31F", null,
      "Flat 5C-down, 4°[22 29] 5°[27 34 41] 6°[39 46 53] down, 7/12-tone down"),

  /// Flat 5C-up, 2°[22 29] 3°[27 34 41] 4°[39 46 53] 5°72 7°[96] down, 5/12-tone down.
  accSagittalFlat5CUp("U+E315", null,
      "Flat 5C-up, 2°[22 29] 3°[27 34 41] 4°[39 46 53] 5°72 7°[96] down, 5/12-tone down"),

  /// Flat 5:11S-down.
  accSagittalFlat5v11SDown("U+E35D", null, "Flat 5:11S-down"),

  /// Flat 5:11S-up.
  accSagittalFlat5v11SUp("U+E34B", null, "Flat 5:11S-up"),

  /// Flat 5:13L-down.
  accSagittalFlat5v13LDown("U+E3DD", null, "Flat 5:13L-down"),

  /// Flat 5:13M-down.
  accSagittalFlat5v13MDown("U+E3D1", null, "Flat 5:13M-down"),

  /// Flat 5:19C-down, 11/20-tone down.
  accSagittalFlat5v19CDown("U+E37F", null, "Flat 5:19C-down, 11/20-tone down"),

  /// Flat 5:19C-up, 9/20-tone down.
  accSagittalFlat5v19CUp("U+E379", null, "Flat 5:19C-up, 9/20-tone down"),

  /// Flat 5:23S-down, 7° down [60 EDO], 7/10-tone down.
  accSagittalFlat5v23SDown(
      "U+E381", null, "Flat 5:23S-down, 7° down [60 EDO], 7/10-tone down"),

  /// Flat 5:23S-up, 3° down [60 EDO], 3/10-tone down.
  accSagittalFlat5v23SUp(
      "U+E377", null, "Flat 5:23S-up, 3° down [60 EDO], 3/10-tone down"),

  /// Flat 5:49M-down.
  accSagittalFlat5v49MDown("U+E3D7", null, "Flat 5:49M-down"),

  /// Flat 5:7k-down.
  accSagittalFlat5v7kDown("U+E31D", null, "Flat 5:7k-down"),

  /// Flat 5:7k-up.
  accSagittalFlat5v7kUp("U+E317", null, "Flat 5:7k-up"),

  /// Flat 7C-down, 4° down [43 EDO], 8° down [72 EDO], 2/3-tone down.
  accSagittalFlat7CDown("U+E321", null,
      "Flat 7C-down, 4° down [43 EDO], 8° down [72 EDO], 2/3-tone down"),

  /// Flat 7C-up, 2° down [43 EDO], 4° down [72 EDO], 1/3-tone down.
  accSagittalFlat7CUp("U+E313", null,
      "Flat 7C-up, 2° down [43 EDO], 4° down [72 EDO], 1/3-tone down"),

  /// Flat 7:11C-down, 6° down [60 EDO], 3/5- tone down.
  accSagittalFlat7v11CDown(
      "U+E35B", null, "Flat 7:11C-down, 6° down [60 EDO], 3/5- tone down"),

  /// Flat 7:11C-up, 4° down [60 EDO], 2/5-tone down.
  accSagittalFlat7v11CUp(
      "U+E34D", null, "Flat 7:11C-up, 4° down [60 EDO], 2/5-tone down"),

  /// Flat 7:11k-down.
  accSagittalFlat7v11kDown("U+E355", null, "Flat 7:11k-down"),

  /// Flat 7:11k-up.
  accSagittalFlat7v11kUp("U+E353", null, "Flat 7:11k-up"),

  /// Flat 7:19C-down.
  accSagittalFlat7v19CDown("U+E3CB", null, "Flat 7:19C-down"),

  /// Flat 7:19C-up.
  accSagittalFlat7v19CUp("U+E3B5", null, "Flat 7:19C-up"),

  /// Fractional tina down, 77/(5⋅37)-schismina down, 0.08 cents down.
  accSagittalFractionalTinaDown("U+E40B", null,
      "Fractional tina down, 77/(5⋅37)-schismina down, 0.08 cents down"),

  /// Fractional tina up, 77/(5⋅37)-schismina up, 0.08 cents up.
  accSagittalFractionalTinaUp("U+E40A", null,
      "Fractional tina up, 77/(5⋅37)-schismina up, 0.08 cents up"),

  /// Grave, 5 schisma down, 2 cents down.
  accSagittalGrave("U+E3F3", null, "Grave, 5 schisma down, 2 cents down"),

  /// Shaft down, (natural for use with only diacritics down).
  accSagittalShaftDown("U+E3F1", null,
      "Shaft down, (natural for use with only diacritics down)"),

  /// Shaft up, (natural for use with only diacritics up).
  accSagittalShaftUp(
      "U+E3F0", null, "Shaft up, (natural for use with only diacritics up)"),

  /// Sharp, (apotome up)[almost all EDOs], 1/2-tone up.
  accSagittalSharp(
      "U+E318", null, "Sharp, (apotome up)[almost all EDOs], 1/2-tone up"),

  /// Sharp 11L-up, 8° up [46 EDO].
  accSagittalSharp11LUp("U+E328", null, "Sharp 11L-up, 8° up [46 EDO]"),

  /// Sharp 11M-up, 3° up [17 31 EDOs], 7° up [46 EDO], 3/4-tone up.
  accSagittalSharp11MUp("U+E326", null,
      "Sharp 11M-up, 3° up [17 31 EDOs], 7° up [46 EDO], 3/4-tone up"),

  /// Sharp 11:19L-up.
  accSagittalSharp11v19LUp("U+E3DA", null, "Sharp 11:19L-up"),

  /// Sharp 11:19M-up.
  accSagittalSharp11v19MUp("U+E3D2", null, "Sharp 11:19M-up"),

  /// Sharp 11:49C-down.
  accSagittalSharp11v49CDown("U+E3B8", null, "Sharp 11:49C-down"),

  /// Sharp 11:49C-up.
  accSagittalSharp11v49CUp("U+E3C6", null, "Sharp 11:49C-up"),

  /// Sharp 143C-down.
  accSagittalSharp143CDown("U+E3BA", null, "Sharp 143C-down"),

  /// Sharp 143C-up.
  accSagittalSharp143CUp("U+E3C4", null, "Sharp 143C-up"),

  /// Sharp 17C-down.
  accSagittalSharp17CDown("U+E350", null, "Sharp 17C-down"),

  /// Sharp 17C-up.
  accSagittalSharp17CUp("U+E356", null, "Sharp 17C-up"),

  /// Sharp 17k-down.
  accSagittalSharp17kDown("U+E3BC", null, "Sharp 17k-down"),

  /// Sharp 17k-up.
  accSagittalSharp17kUp("U+E3C2", null, "Sharp 17k-up"),

  /// Sharp 19C-down.
  accSagittalSharp19CDown("U+E3B6", null, "Sharp 19C-down"),

  /// Sharp 19C-up.
  accSagittalSharp19CUp("U+E3C8", null, "Sharp 19C-up"),

  /// Sharp 19s-down.
  accSagittalSharp19sDown("U+E3BE", null, "Sharp 19s-down"),

  /// Sharp 19s-up.
  accSagittalSharp19sUp("U+E3C0", null, "Sharp 19s-up"),

  /// Sharp 23C-down, 6° up [96 EDO], 3/8-tone up.
  accSagittalSharp23CDown(
      "U+E37A", null, "Sharp 23C-down, 6° up [96 EDO], 3/8-tone up"),

  /// Sharp 23C-up, 10° up [96 EDO], 5/8-tone up.
  accSagittalSharp23CUp(
      "U+E37C", null, "Sharp 23C-up, 10° up [96 EDO], 5/8-tone up"),

  /// Sharp 23S-down.
  accSagittalSharp23SDown("U+E3B0", null, "Sharp 23S-down"),

  /// Sharp 23S-up.
  accSagittalSharp23SUp("U+E3CE", null, "Sharp 23S-up"),

  /// Sharp 25S-down, 3° up [53 EDO].
  accSagittalSharp25SDown("U+E310", null, "Sharp 25S-down, 3° up [53 EDO]"),

  /// Sharp 25S-up, 7° up [53 EDO].
  accSagittalSharp25SUp("U+E322", null, "Sharp 25S-up, 7° up [53 EDO]"),

  /// Sharp 35L-up, 5° up [50 EDO].
  accSagittalSharp35LUp("U+E32A", null, "Sharp 35L-up, 5° up [50 EDO]"),

  /// Sharp 35M-up, 4° up [50 EDO], 6° up [27 EDO], 13/18-tone up.
  accSagittalSharp35MUp("U+E324", null,
      "Sharp 35M-up, 4° up [50 EDO], 6° up [27 EDO], 13/18-tone up"),

  /// Sharp 49L-up.
  accSagittalSharp49LUp("U+E3D8", null, "Sharp 49L-up"),

  /// Sharp 49M-up.
  accSagittalSharp49MUp("U+E3D4", null, "Sharp 49M-up"),

  /// Sharp 49S-down.
  accSagittalSharp49SDown("U+E3B2", null, "Sharp 49S-down"),

  /// Sharp 49S-up.
  accSagittalSharp49SUp("U+E3CC", null, "Sharp 49S-up"),

  /// Sharp 55C-down, 5° up [96 EDO], 5/16-tone up.
  accSagittalSharp55CDown(
      "U+E34E", null, "Sharp 55C-down, 5° up [96 EDO], 5/16-tone up"),

  /// Sharp 55C-up, 11° up [96 EDO], 11/16-tone up.
  accSagittalSharp55CUp(
      "U+E358", null, "Sharp 55C-up, 11° up [96 EDO], 11/16-tone up"),

  /// Sharp 5C-down, 2°[22 29] 3°[27 34 41] 4°[39 46 53] 5°[72] 7°[96] up, 5/12-tone up.
  accSagittalSharp5CDown("U+E314", null,
      "Sharp 5C-down, 2°[22 29] 3°[27 34 41] 4°[39 46 53] 5°[72] 7°[96] up, 5/12-tone up"),

  /// Sharp 5C-up, 4°[22 29] 5°[27 34 41] 6°[39 46 53] up, 7/12-tone up.
  accSagittalSharp5CUp("U+E31E", null,
      "Sharp 5C-up, 4°[22 29] 5°[27 34 41] 6°[39 46 53] up, 7/12-tone up"),

  /// Sharp 5:11S-down.
  accSagittalSharp5v11SDown("U+E34A", null, "Sharp 5:11S-down"),

  /// Sharp 5:11S-up.
  accSagittalSharp5v11SUp("U+E35C", null, "Sharp 5:11S-up"),

  /// Sharp 5:13L-up.
  accSagittalSharp5v13LUp("U+E3DC", null, "Sharp 5:13L-up"),

  /// Sharp 5:13M-up.
  accSagittalSharp5v13MUp("U+E3D0", null, "Sharp 5:13M-up"),

  /// Sharp 5:19C-down, 9/20-tone up.
  accSagittalSharp5v19CDown("U+E378", null, "Sharp 5:19C-down, 9/20-tone up"),

  /// Sharp 5:19C-up, 11/20-tone up.
  accSagittalSharp5v19CUp("U+E37E", null, "Sharp 5:19C-up, 11/20-tone up"),

  /// Sharp 5:23S-down, 3° up [60 EDO], 3/10-tone up.
  accSagittalSharp5v23SDown(
      "U+E376", null, "Sharp 5:23S-down, 3° up [60 EDO], 3/10-tone up"),

  /// Sharp 5:23S-up, 7° up [60 EDO], 7/10-tone up.
  accSagittalSharp5v23SUp(
      "U+E380", null, "Sharp 5:23S-up, 7° up [60 EDO], 7/10-tone up"),

  /// Sharp 5:49M-up, (one and a half apotomes).
  accSagittalSharp5v49MUp(
      "U+E3D6", null, "Sharp 5:49M-up, (one and a half apotomes)"),

  /// Sharp 5:7k-down.
  accSagittalSharp5v7kDown("U+E316", null, "Sharp 5:7k-down"),

  /// Sharp 5:7k-up.
  accSagittalSharp5v7kUp("U+E31C", null, "Sharp 5:7k-up"),

  /// Sharp 7C-down, 2° up [43 EDO], 4° up [72 EDO], 1/3-tone up.
  accSagittalSharp7CDown("U+E312", null,
      "Sharp 7C-down, 2° up [43 EDO], 4° up [72 EDO], 1/3-tone up"),

  /// Sharp 7C-up, 4° up [43 EDO], 8° up [72 EDO], 2/3-tone up.
  accSagittalSharp7CUp("U+E320", null,
      "Sharp 7C-up, 4° up [43 EDO], 8° up [72 EDO], 2/3-tone up"),

  /// Sharp 7:11C-down, 4° up [60 EDO], 2/5-tone up.
  accSagittalSharp7v11CDown(
      "U+E34C", null, "Sharp 7:11C-down, 4° up [60 EDO], 2/5-tone up"),

  /// Sharp 7:11C-up, 6° up [60 EDO], 3/5- tone up.
  accSagittalSharp7v11CUp(
      "U+E35A", null, "Sharp 7:11C-up, 6° up [60 EDO], 3/5- tone up"),

  /// Sharp 7:11k-down.
  accSagittalSharp7v11kDown("U+E352", null, "Sharp 7:11k-down"),

  /// Sharp 7:11k-up.
  accSagittalSharp7v11kUp("U+E354", null, "Sharp 7:11k-up"),

  /// Sharp 7:19C-down.
  accSagittalSharp7v19CDown("U+E3B4", null, "Sharp 7:19C-down"),

  /// Sharp 7:19C-up.
  accSagittalSharp7v19CUp("U+E3CA", null, "Sharp 7:19C-up"),

  /// Unused.
  accSagittalUnused1("U+E31A", null, "Unused"),

  /// Unused.
  accSagittalUnused2("U+E31B", null, "Unused"),

  /// Unused.
  accSagittalUnused3("U+E3DE", null, "Unused"),

  /// Unused.
  accSagittalUnused4("U+E3DF", null, "Unused"),

  /// Combining accordion coupler dot.
  accdnCombDot("U+E8CA", null, "Combining accordion coupler dot"),

  /// Combining left hand, 2 ranks, empty.
  accdnCombLH2RanksEmpty("U+E8C8", null, "Combining left hand, 2 ranks, empty"),

  /// Combining left hand, 3 ranks, empty (square).
  accdnCombLH3RanksEmptySquare(
      "U+E8C9", null, "Combining left hand, 3 ranks, empty (square)"),

  /// Combining right hand, 3 ranks, empty.
  accdnCombRH3RanksEmpty(
      "U+E8C6", null, "Combining right hand, 3 ranks, empty"),

  /// Combining right hand, 4 ranks, empty.
  accdnCombRH4RanksEmpty(
      "U+E8C7", null, "Combining right hand, 4 ranks, empty"),

  /// Diatonic accordion clef.
  accdnDiatonicClef("U+E079", null, "Diatonic accordion clef"),

  /// Left hand, 2 ranks, 16' stop (round).
  accdnLH2Ranks16Round("U+E8BC", null, "Left hand, 2 ranks, 16' stop (round)"),

  /// Left hand, 2 ranks, 8' stop + 16' stop (round).
  accdnLH2Ranks8Plus16Round(
      "U+E8BD", null, "Left hand, 2 ranks, 8' stop + 16' stop (round)"),

  /// Left hand, 2 ranks, 8' stop (round).
  accdnLH2Ranks8Round("U+E8BB", null, "Left hand, 2 ranks, 8' stop (round)"),

  /// Left hand, 2 ranks, full master (round).
  accdnLH2RanksFullMasterRound(
      "U+E8C0", null, "Left hand, 2 ranks, full master (round)"),

  /// Left hand, 2 ranks, master + 16' stop (round).
  accdnLH2RanksMasterPlus16Round(
      "U+E8BF", null, "Left hand, 2 ranks, master + 16' stop (round)"),

  /// Left hand, 2 ranks, master (round).
  accdnLH2RanksMasterRound(
      "U+E8BE", null, "Left hand, 2 ranks, master (round)"),

  /// Left hand, 3 ranks, 2' stop + 8' stop (square).
  accdnLH3Ranks2Plus8Square(
      "U+E8C4", null, "Left hand, 3 ranks, 2' stop + 8' stop (square)"),

  /// Left hand, 3 ranks, 2' stop (square).
  accdnLH3Ranks2Square("U+E8C2", null, "Left hand, 3 ranks, 2' stop (square)"),

  /// Left hand, 3 ranks, 8' stop (square).
  accdnLH3Ranks8Square("U+E8C1", null, "Left hand, 3 ranks, 8' stop (square)"),

  /// Left hand, 3 ranks, double 8' stop (square).
  accdnLH3RanksDouble8Square(
      "U+E8C3", null, "Left hand, 3 ranks, double 8' stop (square)"),

  /// Left hand, 3 ranks, 2' stop + double 8' stop (tutti) (square).
  accdnLH3RanksTuttiSquare("U+E8C5", null,
      "Left hand, 3 ranks, 2' stop + double 8' stop (tutti) (square)"),

  /// Pull.
  accdnPull("U+E8CC", null, "Pull"),

  /// Push.
  accdnPush("U+E8CB", null, "Push"),

  /// Right hand, 3 ranks, 8' stop + upper tremolo 8' stop + 16' stop (accordion).
  accdnRH3RanksAccordion("U+E8AC", null,
      "Right hand, 3 ranks, 8' stop + upper tremolo 8' stop + 16' stop (accordion)"),

  /// Right hand, 3 ranks, lower tremolo 8' stop + 8' stop + upper tremolo 8' stop (authentic musette).
  accdnRH3RanksAuthenticMusette("U+E8A8", null,
      "Right hand, 3 ranks, lower tremolo 8' stop + 8' stop + upper tremolo 8' stop (authentic musette)"),

  /// Right hand, 3 ranks, 8' stop + 16' stop (bandoneón).
  accdnRH3RanksBandoneon(
      "U+E8AB", null, "Right hand, 3 ranks, 8' stop + 16' stop (bandoneón)"),

  /// Right hand, 3 ranks, 16' stop (bassoon).
  accdnRH3RanksBassoon(
      "U+E8A4", null, "Right hand, 3 ranks, 16' stop (bassoon)"),

  /// Right hand, 3 ranks, 8' stop (clarinet).
  accdnRH3RanksClarinet(
      "U+E8A1", null, "Right hand, 3 ranks, 8' stop (clarinet)"),

  /// Right hand, 3 ranks, lower tremolo 8' stop + 8' stop + upper tremolo 8' stop + 16' stop.
  accdnRH3RanksDoubleTremoloLower8ve("U+E8B1", null,
      "Right hand, 3 ranks, lower tremolo 8' stop + 8' stop + upper tremolo 8' stop + 16' stop"),

  /// Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + 8' stop + upper tremolo 8' stop.
  accdnRH3RanksDoubleTremoloUpper8ve("U+E8B2", null,
      "Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + 8' stop + upper tremolo 8' stop"),

  /// Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + 8' stop + upper tremolo 8' stop + 16' stop.
  accdnRH3RanksFullFactory("U+E8B3", null,
      "Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + 8' stop + upper tremolo 8' stop + 16' stop"),

  /// Right hand, 3 ranks, 4' stop + 8' stop + 16' stop (harmonium).
  accdnRH3RanksHarmonium("U+E8AA", null,
      "Right hand, 3 ranks, 4' stop + 8' stop + 16' stop (harmonium)"),

  /// Right hand, 3 ranks, 4' stop + 8' stop + upper tremolo 8' stop (imitation musette).
  accdnRH3RanksImitationMusette("U+E8A7", null,
      "Right hand, 3 ranks, 4' stop + 8' stop + upper tremolo 8' stop (imitation musette)"),

  /// Right hand, 3 ranks, lower tremolo 8' stop.
  accdnRH3RanksLowerTremolo8(
      "U+E8A3", null, "Right hand, 3 ranks, lower tremolo 8' stop"),

  /// Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + upper tremolo 8' stop + 16' stop (master).
  accdnRH3RanksMaster("U+E8AD", null,
      "Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + upper tremolo 8' stop + 16' stop (master)"),

  /// Right hand, 3 ranks, 4' stop + 8' stop (oboe).
  accdnRH3RanksOboe(
      "U+E8A5", null, "Right hand, 3 ranks, 4' stop + 8' stop (oboe)"),

  /// Right hand, 3 ranks, 4' stop + 16' stop (organ).
  accdnRH3RanksOrgan(
      "U+E8A9", null, "Right hand, 3 ranks, 4' stop + 16' stop (organ)"),

  /// Right hand, 3 ranks, 4' stop (piccolo).
  accdnRH3RanksPiccolo(
      "U+E8A0", null, "Right hand, 3 ranks, 4' stop (piccolo)"),

  /// Right hand, 3 ranks, lower tremolo 8' stop + upper tremolo 8' stop + 16' stop.
  accdnRH3RanksTremoloLower8ve("U+E8AF", null,
      "Right hand, 3 ranks, lower tremolo 8' stop + upper tremolo 8' stop + 16' stop"),

  /// Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + upper tremolo 8' stop.
  accdnRH3RanksTremoloUpper8ve("U+E8B0", null,
      "Right hand, 3 ranks, 4' stop + lower tremolo 8' stop + upper tremolo 8' stop"),

  /// Right hand, 3 ranks, lower tremolo 8' stop + upper tremolo 8' stop.
  accdnRH3RanksTwoChoirs("U+E8AE", null,
      "Right hand, 3 ranks, lower tremolo 8' stop + upper tremolo 8' stop"),

  /// Right hand, 3 ranks, upper tremolo 8' stop.
  accdnRH3RanksUpperTremolo8(
      "U+E8A2", null, "Right hand, 3 ranks, upper tremolo 8' stop"),

  /// Right hand, 3 ranks, 8' stop + upper tremolo 8' stop (violin).
  accdnRH3RanksViolin("U+E8A6", null,
      "Right hand, 3 ranks, 8' stop + upper tremolo 8' stop (violin)"),

  /// Right hand, 4 ranks, alto.
  accdnRH4RanksAlto("U+E8B5", null, "Right hand, 4 ranks, alto"),

  /// Right hand, 4 ranks, bass/alto.
  accdnRH4RanksBassAlto("U+E8BA", null, "Right hand, 4 ranks, bass/alto"),

  /// Right hand, 4 ranks, master.
  accdnRH4RanksMaster("U+E8B7", null, "Right hand, 4 ranks, master"),

  /// Right hand, 4 ranks, soft bass.
  accdnRH4RanksSoftBass("U+E8B8", null, "Right hand, 4 ranks, soft bass"),

  /// Right hand, 4 ranks, soft tenor.
  accdnRH4RanksSoftTenor("U+E8B9", null, "Right hand, 4 ranks, soft tenor"),

  /// Right hand, 4 ranks, soprano.
  accdnRH4RanksSoprano("U+E8B4", null, "Right hand, 4 ranks, soprano"),

  /// Right hand, 4 ranks, tenor.
  accdnRH4RanksTenor("U+E8B6", null, "Right hand, 4 ranks, tenor"),

  /// Ricochet (2 tones).
  accdnRicochet2("U+E8CD", null, "Ricochet (2 tones)"),

  /// Ricochet (3 tones).
  accdnRicochet3("U+E8CE", null, "Ricochet (3 tones)"),

  /// Ricochet (4 tones).
  accdnRicochet4("U+E8CF", null, "Ricochet (4 tones)"),

  /// Ricochet (5 tones).
  accdnRicochet5("U+E8D0", null, "Ricochet (5 tones)"),

  /// Ricochet (6 tones).
  accdnRicochet6("U+E8D1", null, "Ricochet (6 tones)"),

  /// Combining ricochet for stem (2 tones).
  accdnRicochetStem2("U+E8D2", null, "Combining ricochet for stem (2 tones)"),

  /// Combining ricochet for stem (3 tones).
  accdnRicochetStem3("U+E8D3", null, "Combining ricochet for stem (3 tones)"),

  /// Combining ricochet for stem (4 tones).
  accdnRicochetStem4("U+E8D4", null, "Combining ricochet for stem (4 tones)"),

  /// Combining ricochet for stem (5 tones).
  accdnRicochetStem5("U+E8D5", null, "Combining ricochet for stem (5 tones)"),

  /// Combining ricochet for stem (6 tones).
  accdnRicochetStem6("U+E8D6", null, "Combining ricochet for stem (6 tones)"),

  /// 1-comma flat.
  accidental1CommaFlat("U+E454", null, "1-comma flat"),

  /// 1-comma sharp.
  accidental1CommaSharp("U+E450", null, "1-comma sharp"),

  /// 2-comma flat.
  accidental2CommaFlat("U+E455", null, "2-comma flat"),

  /// 2-comma sharp.
  accidental2CommaSharp("U+E451", null, "2-comma sharp"),

  /// 3-comma flat.
  accidental3CommaFlat("U+E456", null, "3-comma flat"),

  /// 3-comma sharp.
  accidental3CommaSharp("U+E452", null, "3-comma sharp"),

  /// 4-comma flat.
  accidental4CommaFlat("U+E457", null, "4-comma flat"),

  /// 5-comma sharp.
  accidental5CommaSharp("U+E453", null, "5-comma sharp"),

  /// Arrow down (lower by one quarter-tone).
  accidentalArrowDown("U+E27B", null, "Arrow down (lower by one quarter-tone)"),

  /// Arrow up (raise by one quarter-tone).
  accidentalArrowUp("U+E27A", null, "Arrow up (raise by one quarter-tone)"),

  /// Bakiye (flat).
  accidentalBakiyeFlat("U+E442", null, "Bakiye (flat)"),

  /// Bakiye (sharp).
  accidentalBakiyeSharp("U+E445", null, "Bakiye (sharp)"),

  /// Accidental bracket, left.
  accidentalBracketLeft("U+E26C", null, "Accidental bracket, left"),

  /// Accidental bracket, right.
  accidentalBracketRight("U+E26D", null, "Accidental bracket, right"),

  /// Büyük mücenneb (flat).
  accidentalBuyukMucennebFlat("U+E440", null, "Büyük mücenneb (flat)"),

  /// Büyük mücenneb (sharp).
  accidentalBuyukMucennebSharp("U+E447", null, "Büyük mücenneb (sharp)"),

  /// Combining close curly brace.
  accidentalCombiningCloseCurlyBrace(
      "U+E2EF", null, "Combining close curly brace"),

  /// Combining lower by one 17-limit schisma.
  accidentalCombiningLower17Schisma(
      "U+E2E6", null, "Combining lower by one 17-limit schisma"),

  /// Combining lower by one 19-limit schisma.
  accidentalCombiningLower19Schisma(
      "U+E2E8", null, "Combining lower by one 19-limit schisma"),

  /// Combining lower by one 23-limit comma.
  accidentalCombiningLower23Limit29LimitComma(
      "U+E2EA", null, "Combining lower by one 23-limit comma"),

  /// Combining lower by one 29-limit comma.
  accidentalCombiningLower29LimitComma(
      "U+EE50", null, "Combining lower by one 29-limit comma"),

  /// Combining lower by one 31-limit schisma.
  accidentalCombiningLower31Schisma(
      "U+E2EC", null, "Combining lower by one 31-limit schisma"),

  /// Combining lower by one 37-limit quartertone.
  accidentalCombiningLower37Quartertone(
      "U+EE52", null, "Combining lower by one 37-limit quartertone"),

  /// Combining lower by one 41-limit comma.
  accidentalCombiningLower41Comma(
      "U+EE54", null, "Combining lower by one 41-limit comma"),

  /// Combining lower by one 43-limit comma.
  accidentalCombiningLower43Comma(
      "U+EE56", null, "Combining lower by one 43-limit comma"),

  /// Combining lower by one 47-limit quartertone.
  accidentalCombiningLower47Quartertone(
      "U+EE58", null, "Combining lower by one 47-limit quartertone"),

  /// Combining lower by one 53-limit comma.
  accidentalCombiningLower53LimitComma(
      "U+E2F7", null, "Combining lower by one 53-limit comma"),

  /// Combining open curly brace.
  accidentalCombiningOpenCurlyBrace(
      "U+E2EE", null, "Combining open curly brace"),

  /// Combining raise by one 17-limit schisma.
  accidentalCombiningRaise17Schisma(
      "U+E2E7", null, "Combining raise by one 17-limit schisma"),

  /// Combining raise by one 19-limit schisma.
  accidentalCombiningRaise19Schisma(
      "U+E2E9", null, "Combining raise by one 19-limit schisma"),

  /// Combining raise by one 23-limit comma.
  accidentalCombiningRaise23Limit29LimitComma(
      "U+E2EB", null, "Combining raise by one 23-limit comma"),

  /// Combining raise by one 29-limit comma.
  accidentalCombiningRaise29LimitComma(
      "U+EE51", null, "Combining raise by one 29-limit comma"),

  /// Combining raise by one 31-limit schisma.
  accidentalCombiningRaise31Schisma(
      "U+E2ED", null, "Combining raise by one 31-limit schisma"),

  /// Combining raise by one 37-limit quartertone.
  accidentalCombiningRaise37Quartertone(
      "U+EE53", null, "Combining raise by one 37-limit quartertone"),

  /// Combining raise by one 41-limit comma.
  accidentalCombiningRaise41Comma(
      "U+EE55", null, "Combining raise by one 41-limit comma"),

  /// Combining raise by one 43-limit comma.
  accidentalCombiningRaise43Comma(
      "U+EE57", null, "Combining raise by one 43-limit comma"),

  /// Combining raise by one 47-limit quartertone.
  accidentalCombiningRaise47Quartertone(
      "U+EE59", null, "Combining raise by one 47-limit quartertone"),

  /// Combining raise by one 53-limit comma.
  accidentalCombiningRaise53LimitComma(
      "U+E2F8", null, "Combining raise by one 53-limit comma"),

  /// Syntonic/Didymus comma (80:81) down (Bosanquet).
  accidentalCommaSlashDown(
      "U+E47A", null, "Syntonic/Didymus comma (80:81) down (Bosanquet)"),

  /// Syntonic/Didymus comma (80:81) up (Bosanquet).
  accidentalCommaSlashUp(
      "U+E479", null, "Syntonic/Didymus comma (80:81) up (Bosanquet)"),

  /// Double flat.
  accidentalDoubleFlat("U+E264", "U+1D12B", "Double flat"),

  /// Arabic double flat.
  accidentalDoubleFlatArabic("U+ED30", null, "Arabic double flat"),

  /// Double flat equal tempered semitone.
  accidentalDoubleFlatEqualTempered(
      "U+E2F0", null, "Double flat equal tempered semitone"),

  /// Double flat lowered by one syntonic comma.
  accidentalDoubleFlatOneArrowDown(
      "U+E2C0", null, "Double flat lowered by one syntonic comma"),

  /// Double flat raised by one syntonic comma.
  accidentalDoubleFlatOneArrowUp(
      "U+E2C5", null, "Double flat raised by one syntonic comma"),

  /// Reversed double flat.
  accidentalDoubleFlatReversed("U+E483", null, "Reversed double flat"),

  /// Double flat lowered by three syntonic commas.
  accidentalDoubleFlatThreeArrowsDown(
      "U+E2D4", null, "Double flat lowered by three syntonic commas"),

  /// Double flat raised by three syntonic commas.
  accidentalDoubleFlatThreeArrowsUp(
      "U+E2D9", null, "Double flat raised by three syntonic commas"),

  /// Turned double flat.
  accidentalDoubleFlatTurned("U+E485", null, "Turned double flat"),

  /// Double flat lowered by two syntonic commas.
  accidentalDoubleFlatTwoArrowsDown(
      "U+E2CA", null, "Double flat lowered by two syntonic commas"),

  /// Double flat raised by two syntonic commas.
  accidentalDoubleFlatTwoArrowsUp(
      "U+E2CF", null, "Double flat raised by two syntonic commas"),

  /// Double sharp.
  accidentalDoubleSharp("U+E263", "U+1D12A", "Double sharp"),

  /// Arabic double sharp.
  accidentalDoubleSharpArabic("U+ED38", null, "Arabic double sharp"),

  /// Double sharp equal tempered semitone.
  accidentalDoubleSharpEqualTempered(
      "U+E2F4", null, "Double sharp equal tempered semitone"),

  /// Double sharp lowered by one syntonic comma.
  accidentalDoubleSharpOneArrowDown(
      "U+E2C4", null, "Double sharp lowered by one syntonic comma"),

  /// Double sharp raised by one syntonic comma.
  accidentalDoubleSharpOneArrowUp(
      "U+E2C9", null, "Double sharp raised by one syntonic comma"),

  /// Double sharp lowered by three syntonic commas.
  accidentalDoubleSharpThreeArrowsDown(
      "U+E2D8", null, "Double sharp lowered by three syntonic commas"),

  /// Double sharp raised by three syntonic commas.
  accidentalDoubleSharpThreeArrowsUp(
      "U+E2DD", null, "Double sharp raised by three syntonic commas"),

  /// Double sharp lowered by two syntonic commas.
  accidentalDoubleSharpTwoArrowsDown(
      "U+E2CE", null, "Double sharp lowered by two syntonic commas"),

  /// Double sharp raised by two syntonic commas.
  accidentalDoubleSharpTwoArrowsUp(
      "U+E2D3", null, "Double sharp raised by two syntonic commas"),

  /// Enharmonically reinterpret accidental almost equal to.
  accidentalEnharmonicAlmostEqualTo(
      "U+E2FA", null, "Enharmonically reinterpret accidental almost equal to"),

  /// Enharmonically reinterpret accidental equals.
  accidentalEnharmonicEquals(
      "U+E2FB", null, "Enharmonically reinterpret accidental equals"),

  /// Enharmonically reinterpret accidental tilde.
  accidentalEnharmonicTilde(
      "U+E2F9", null, "Enharmonically reinterpret accidental tilde"),

  /// Filled reversed flat and flat.
  accidentalFilledReversedFlatAndFlat(
      "U+E296", null, "Filled reversed flat and flat"),

  /// Filled reversed flat and flat with arrow down.
  accidentalFilledReversedFlatAndFlatArrowDown(
      "U+E298", null, "Filled reversed flat and flat with arrow down"),

  /// Filled reversed flat and flat with arrow up.
  accidentalFilledReversedFlatAndFlatArrowUp(
      "U+E297", null, "Filled reversed flat and flat with arrow up"),

  /// Filled reversed flat with arrow down.
  accidentalFilledReversedFlatArrowDown(
      "U+E293", null, "Filled reversed flat with arrow down"),

  /// Filled reversed flat with arrow up.
  accidentalFilledReversedFlatArrowUp(
      "U+E292", null, "Filled reversed flat with arrow up"),

  /// Five-quarter-tones flat.
  accidentalFiveQuarterTonesFlatArrowDown(
      "U+E279", null, "Five-quarter-tones flat"),

  /// Five-quarter-tones sharp.
  accidentalFiveQuarterTonesSharpArrowUp(
      "U+E276", null, "Five-quarter-tones sharp"),

  /// Flat.
  accidentalFlat("U+E260", "U+266D", "Flat"),

  /// Arabic half-tone flat.
  accidentalFlatArabic("U+ED32", null, "Arabic half-tone flat"),

  /// Flat equal tempered semitone.
  accidentalFlatEqualTempered("U+E2F1", null, "Flat equal tempered semitone"),

  /// Lowered flat (Stockhausen).
  accidentalFlatLoweredStockhausen(
      "U+ED53", null, "Lowered flat (Stockhausen)"),

  /// Flat lowered by one syntonic comma.
  accidentalFlatOneArrowDown(
      "U+E2C1", null, "Flat lowered by one syntonic comma"),

  /// Flat raised by one syntonic comma.
  accidentalFlatOneArrowUp("U+E2C6", null, "Flat raised by one syntonic comma"),

  /// Raised flat (Stockhausen).
  accidentalFlatRaisedStockhausen("U+ED52", null, "Raised flat (Stockhausen)"),

  /// Repeated flat, note on line (Stockhausen).
  accidentalFlatRepeatedLineStockhausen(
      "U+ED5C", null, "Repeated flat, note on line (Stockhausen)"),

  /// Repeated flat, note in space (Stockhausen).
  accidentalFlatRepeatedSpaceStockhausen(
      "U+ED5B", null, "Repeated flat, note in space (Stockhausen)"),

  /// Flat lowered by three syntonic commas.
  accidentalFlatThreeArrowsDown(
      "U+E2D5", null, "Flat lowered by three syntonic commas"),

  /// Flat raised by three syntonic commas.
  accidentalFlatThreeArrowsUp(
      "U+E2DA", null, "Flat raised by three syntonic commas"),

  /// Turned flat.
  accidentalFlatTurned("U+E484", null, "Turned flat"),

  /// Flat lowered by two syntonic commas.
  accidentalFlatTwoArrowsDown(
      "U+E2CB", null, "Flat lowered by two syntonic commas"),

  /// Flat raised by two syntonic commas.
  accidentalFlatTwoArrowsUp(
      "U+E2D0", null, "Flat raised by two syntonic commas"),

  /// Quarter-tone higher (Alois Hába).
  accidentalHabaFlatQuarterToneHigher(
      "U+EE65", null, "Quarter-tone higher (Alois Hába)"),

  /// Three quarter-tones lower (Alois Hába).
  accidentalHabaFlatThreeQuarterTonesLower(
      "U+EE69", null, "Three quarter-tones lower (Alois Hába)"),

  /// Quarter-tone higher (Alois Hába).
  accidentalHabaQuarterToneHigher(
      "U+EE64", null, "Quarter-tone higher (Alois Hába)"),

  /// Quarter-tone lower (Alois Hába).
  accidentalHabaQuarterToneLower(
      "U+EE67", null, "Quarter-tone lower (Alois Hába)"),

  /// Quarter-tone lower (Alois Hába).
  accidentalHabaSharpQuarterToneLower(
      "U+EE68", null, "Quarter-tone lower (Alois Hába)"),

  /// Three quarter-tones higher (Alois Hába).
  accidentalHabaSharpThreeQuarterTonesHigher(
      "U+EE66", null, "Three quarter-tones higher (Alois Hába)"),

  /// Half sharp with arrow down.
  accidentalHalfSharpArrowDown("U+E29A", null, "Half sharp with arrow down"),

  /// Half sharp with arrow up.
  accidentalHalfSharpArrowUp("U+E299", null, "Half sharp with arrow up"),

  /// Thirteen (raise by 65:64).
  accidentalJohnston13("U+E2B6", null, "Thirteen (raise by 65:64)"),

  /// Inverted 13 (lower by 65:64).
  accidentalJohnston31("U+E2B7", null, "Inverted 13 (lower by 65:64)"),

  /// Down arrow (lower by 33:32).
  accidentalJohnstonDown("U+E2B5", null, "Down arrow (lower by 33:32)"),

  /// Inverted seven (raise by 36:35).
  accidentalJohnstonEl("U+E2B2", null, "Inverted seven (raise by 36:35)"),

  /// Minus (lower by 81:80).
  accidentalJohnstonMinus("U+E2B1", null, "Minus (lower by 81:80)"),

  /// Plus (raise by 81:80).
  accidentalJohnstonPlus("U+E2B0", null, "Plus (raise by 81:80)"),

  /// Seven (lower by 36:35).
  accidentalJohnstonSeven("U+E2B3", null, "Seven (lower by 36:35)"),

  /// Up arrow (raise by 33:32).
  accidentalJohnstonUp("U+E2B4", null, "Up arrow (raise by 33:32)"),

  /// Koma (flat).
  accidentalKomaFlat("U+E443", null, "Koma (flat)"),

  /// Koma (sharp).
  accidentalKomaSharp("U+E444", null, "Koma (sharp)"),

  /// Koron (quarter tone flat).
  accidentalKoron("U+E460", null, "Koron (quarter tone flat)"),

  /// Küçük mücenneb (flat).
  accidentalKucukMucennebFlat("U+E441", null, "Küçük mücenneb (flat)"),

  /// Küçük mücenneb (sharp).
  accidentalKucukMucennebSharp("U+E446", null, "Küçük mücenneb (sharp)"),

  /// Large double sharp.
  accidentalLargeDoubleSharp("U+E47D", null, "Large double sharp"),

  /// Lower by one septimal comma.
  accidentalLowerOneSeptimalComma(
      "U+E2DE", null, "Lower by one septimal comma"),

  /// Lower by one tridecimal quartertone.
  accidentalLowerOneTridecimalQuartertone(
      "U+E2E4", null, "Lower by one tridecimal quartertone"),

  /// Lower by one undecimal quartertone.
  accidentalLowerOneUndecimalQuartertone(
      "U+E2E2", null, "Lower by one undecimal quartertone"),

  /// Lower by two septimal commas.
  accidentalLowerTwoSeptimalCommas(
      "U+E2E0", null, "Lower by two septimal commas"),

  /// Lowered (Stockhausen).
  accidentalLoweredStockhausen("U+ED51", null, "Lowered (Stockhausen)"),

  /// Narrow reversed flat(quarter-tone flat).
  accidentalNarrowReversedFlat(
      "U+E284", null, "Narrow reversed flat(quarter-tone flat)"),

  /// Narrow reversed flat and flat(three-quarter-tones flat).
  accidentalNarrowReversedFlatAndFlat("U+E285", null,
      "Narrow reversed flat and flat(three-quarter-tones flat)"),

  /// Natural.
  accidentalNatural("U+E261", "U+266E", "Natural"),

  /// Arabic natural.
  accidentalNaturalArabic("U+ED34", null, "Arabic natural"),

  /// Natural equal tempered semitone.
  accidentalNaturalEqualTempered(
      "U+E2F2", null, "Natural equal tempered semitone"),

  /// Natural flat.
  accidentalNaturalFlat("U+E267", null, "Natural flat"),

  /// Lowered natural (Stockhausen).
  accidentalNaturalLoweredStockhausen(
      "U+ED55", null, "Lowered natural (Stockhausen)"),

  /// Natural lowered by one syntonic comma.
  accidentalNaturalOneArrowDown(
      "U+E2C2", null, "Natural lowered by one syntonic comma"),

  /// Natural raised by one syntonic comma.
  accidentalNaturalOneArrowUp(
      "U+E2C7", null, "Natural raised by one syntonic comma"),

  /// Raised natural (Stockhausen).
  accidentalNaturalRaisedStockhausen(
      "U+ED54", null, "Raised natural (Stockhausen)"),

  /// Reversed natural.
  accidentalNaturalReversed("U+E482", null, "Reversed natural"),

  /// Natural sharp.
  accidentalNaturalSharp("U+E268", null, "Natural sharp"),

  /// Natural lowered by three syntonic commas.
  accidentalNaturalThreeArrowsDown(
      "U+E2D6", null, "Natural lowered by three syntonic commas"),

  /// Natural raised by three syntonic commas.
  accidentalNaturalThreeArrowsUp(
      "U+E2DB", null, "Natural raised by three syntonic commas"),

  /// Natural lowered by two syntonic commas.
  accidentalNaturalTwoArrowsDown(
      "U+E2CC", null, "Natural lowered by two syntonic commas"),

  /// Natural raised by two syntonic commas.
  accidentalNaturalTwoArrowsUp(
      "U+E2D1", null, "Natural raised by two syntonic commas"),

  /// One and a half sharps with arrow down.
  accidentalOneAndAHalfSharpsArrowDown(
      "U+E29C", null, "One and a half sharps with arrow down"),

  /// One and a half sharps with arrow up.
  accidentalOneAndAHalfSharpsArrowUp(
      "U+E29B", null, "One and a half sharps with arrow up"),

  /// One-quarter-tone flat (Ferneyhough).
  accidentalOneQuarterToneFlatFerneyhough(
      "U+E48F", null, "One-quarter-tone flat (Ferneyhough)"),

  /// One-quarter-tone flat (Stockhausen).
  accidentalOneQuarterToneFlatStockhausen(
      "U+ED59", null, "One-quarter-tone flat (Stockhausen)"),

  /// One-quarter-tone sharp (Ferneyhough).
  accidentalOneQuarterToneSharpFerneyhough(
      "U+E48E", null, "One-quarter-tone sharp (Ferneyhough)"),

  /// One-quarter-tone sharp (Stockhausen).
  accidentalOneQuarterToneSharpStockhausen(
      "U+ED58", null, "One-quarter-tone sharp (Stockhausen)"),

  /// One-third-tone flat (Ferneyhough).
  accidentalOneThirdToneFlatFerneyhough(
      "U+E48B", null, "One-third-tone flat (Ferneyhough)"),

  /// One-third-tone sharp (Ferneyhough).
  accidentalOneThirdToneSharpFerneyhough(
      "U+E48A", null, "One-third-tone sharp (Ferneyhough)"),

  /// Accidental parenthesis, left.
  accidentalParensLeft("U+E26A", null, "Accidental parenthesis, left"),

  /// Accidental parenthesis, right.
  accidentalParensRight("U+E26B", null, "Accidental parenthesis, right"),

  /// Lower by one equal tempered quarter-tone.
  accidentalQuarterFlatEqualTempered(
      "U+E2F5", null, "Lower by one equal tempered quarter-tone"),

  /// Raise by one equal tempered quarter tone.
  accidentalQuarterSharpEqualTempered(
      "U+E2F6", null, "Raise by one equal tempered quarter tone"),

  /// Quarter-tone flat.
  accidentalQuarterToneFlat4("U+E47F", "U+1D133", "Quarter-tone flat"),

  /// Arabic quarter-tone flat.
  accidentalQuarterToneFlatArabic("U+ED33", null, "Arabic quarter-tone flat"),

  /// Quarter-tone flat.
  accidentalQuarterToneFlatArrowUp("U+E270", "U+1D12C", "Quarter-tone flat"),

  /// Filled reversed flat (quarter-tone flat).
  accidentalQuarterToneFlatFilledReversed(
      "U+E480", null, "Filled reversed flat (quarter-tone flat)"),

  /// Quarter-tone flat.
  accidentalQuarterToneFlatNaturalArrowDown(
      "U+E273", "U+1D12F", "Quarter-tone flat"),

  /// Quarter tone flat (Penderecki).
  accidentalQuarterToneFlatPenderecki(
      "U+E478", null, "Quarter tone flat (Penderecki)"),

  /// Reversed flat (quarter-tone flat) (Stein).
  accidentalQuarterToneFlatStein(
      "U+E280", null, "Reversed flat (quarter-tone flat) (Stein)"),

  /// Quarter-tone flat (van Blankenburg).
  accidentalQuarterToneFlatVanBlankenburg(
      "U+E488", null, "Quarter-tone flat (van Blankenburg)"),

  /// Quarter-tone sharp.
  accidentalQuarterToneSharp4("U+E47E", "U+1D132", "Quarter-tone sharp"),

  /// Arabic quarter-tone sharp.
  accidentalQuarterToneSharpArabic("U+ED35", null, "Arabic quarter-tone sharp"),

  /// Quarter-tone sharp.
  accidentalQuarterToneSharpArrowDown(
      "U+E275", "U+1D131", "Quarter-tone sharp"),

  /// Quarter tone sharp (Bussotti).
  accidentalQuarterToneSharpBusotti(
      "U+E472", null, "Quarter tone sharp (Bussotti)"),

  /// Quarter-tone sharp.
  accidentalQuarterToneSharpNaturalArrowUp(
      "U+E272", "U+1D12E", "Quarter-tone sharp"),

  /// Half sharp (quarter-tone sharp) (Stein).
  accidentalQuarterToneSharpStein(
      "U+E282", null, "Half sharp (quarter-tone sharp) (Stein)"),

  /// Quarter tone sharp with wiggly tail.
  accidentalQuarterToneSharpWiggle(
      "U+E475", null, "Quarter tone sharp with wiggly tail"),

  /// Raise by one septimal comma.
  accidentalRaiseOneSeptimalComma(
      "U+E2DF", null, "Raise by one septimal comma"),

  /// Raise by one tridecimal quartertone.
  accidentalRaiseOneTridecimalQuartertone(
      "U+E2E5", null, "Raise by one tridecimal quartertone"),

  /// Raise by one undecimal quartertone.
  accidentalRaiseOneUndecimalQuartertone(
      "U+E2E3", null, "Raise by one undecimal quartertone"),

  /// Raise by two septimal commas.
  accidentalRaiseTwoSeptimalCommas(
      "U+E2E1", null, "Raise by two septimal commas"),

  /// Raised (Stockhausen).
  accidentalRaisedStockhausen("U+ED50", null, "Raised (Stockhausen)"),

  /// Reversed flat and flat with arrow down.
  accidentalReversedFlatAndFlatArrowDown(
      "U+E295", null, "Reversed flat and flat with arrow down"),

  /// Reversed flat and flat with arrow up.
  accidentalReversedFlatAndFlatArrowUp(
      "U+E294", null, "Reversed flat and flat with arrow up"),

  /// Reversed flat with arrow down.
  accidentalReversedFlatArrowDown(
      "U+E291", null, "Reversed flat with arrow down"),

  /// Reversed flat with arrow up.
  accidentalReversedFlatArrowUp("U+E290", null, "Reversed flat with arrow up"),

  /// Sharp.
  accidentalSharp("U+E262", "U+266F", "Sharp"),

  /// Arabic half-tone sharp.
  accidentalSharpArabic("U+ED36", null, "Arabic half-tone sharp"),

  /// Sharp equal tempered semitone.
  accidentalSharpEqualTempered("U+E2F3", null, "Sharp equal tempered semitone"),

  /// Lowered sharp (Stockhausen).
  accidentalSharpLoweredStockhausen(
      "U+ED57", null, "Lowered sharp (Stockhausen)"),

  /// Sharp lowered by one syntonic comma.
  accidentalSharpOneArrowDown(
      "U+E2C3", null, "Sharp lowered by one syntonic comma"),

  /// Sharp raised by one syntonic comma.
  accidentalSharpOneArrowUp(
      "U+E2C8", null, "Sharp raised by one syntonic comma"),

  /// One or three quarter tones sharp.
  accidentalSharpOneHorizontalStroke(
      "U+E473", null, "One or three quarter tones sharp"),

  /// Raised sharp (Stockhausen).
  accidentalSharpRaisedStockhausen(
      "U+ED56", null, "Raised sharp (Stockhausen)"),

  /// Repeated sharp, note on line (Stockhausen).
  accidentalSharpRepeatedLineStockhausen(
      "U+ED5E", null, "Repeated sharp, note on line (Stockhausen)"),

  /// Repeated sharp, note in space (Stockhausen).
  accidentalSharpRepeatedSpaceStockhausen(
      "U+ED5D", null, "Repeated sharp, note in space (Stockhausen)"),

  /// Reversed sharp.
  accidentalSharpReversed("U+E481", null, "Reversed sharp"),

  /// Sharp sharp.
  accidentalSharpSharp("U+E269", null, "Sharp sharp"),

  /// Sharp lowered by three syntonic commas.
  accidentalSharpThreeArrowsDown(
      "U+E2D7", null, "Sharp lowered by three syntonic commas"),

  /// Sharp raised by three syntonic commas.
  accidentalSharpThreeArrowsUp(
      "U+E2DC", null, "Sharp raised by three syntonic commas"),

  /// Sharp lowered by two syntonic commas.
  accidentalSharpTwoArrowsDown(
      "U+E2CD", null, "Sharp lowered by two syntonic commas"),

  /// Sharp raised by two syntonic commas.
  accidentalSharpTwoArrowsUp(
      "U+E2D2", null, "Sharp raised by two syntonic commas"),

  /// 1/12 tone low.
  accidentalSims12Down("U+E2A0", null, "1/12 tone low"),

  /// 1/12 tone high.
  accidentalSims12Up("U+E2A3", null, "1/12 tone high"),

  /// 1/4 tone low.
  accidentalSims4Down("U+E2A2", null, "1/4 tone low"),

  /// 1/4 tone high.
  accidentalSims4Up("U+E2A5", null, "1/4 tone high"),

  /// 1/6 tone low.
  accidentalSims6Down("U+E2A1", null, "1/6 tone low"),

  /// 1/6 tone high.
  accidentalSims6Up("U+E2A4", null, "1/6 tone high"),

  /// Sori (quarter tone sharp).
  accidentalSori("U+E461", null, "Sori (quarter tone sharp)"),

  /// Byzantine-style Bakiye flat (Tavener).
  accidentalTavenerFlat(
      "U+E477", null, "Byzantine-style Bakiye flat (Tavener)"),

  /// Byzantine-style Büyük mücenneb sharp (Tavener).
  accidentalTavenerSharp(
      "U+E476", null, "Byzantine-style Büyük mücenneb sharp (Tavener)"),

  /// Arabic three-quarter-tones flat.
  accidentalThreeQuarterTonesFlatArabic(
      "U+ED31", null, "Arabic three-quarter-tones flat"),

  /// Three-quarter-tones flat.
  accidentalThreeQuarterTonesFlatArrowDown(
      "U+E271", "U+1D12D", "Three-quarter-tones flat"),

  /// Three-quarter-tones flat.
  accidentalThreeQuarterTonesFlatArrowUp(
      "U+E278", null, "Three-quarter-tones flat"),

  /// Three-quarter-tones flat (Couper).
  accidentalThreeQuarterTonesFlatCouper(
      "U+E489", null, "Three-quarter-tones flat (Couper)"),

  /// Three-quarter-tones flat (Grisey).
  accidentalThreeQuarterTonesFlatGrisey(
      "U+E486", null, "Three-quarter-tones flat (Grisey)"),

  /// Three-quarter-tones flat (Tartini).
  accidentalThreeQuarterTonesFlatTartini(
      "U+E487", null, "Three-quarter-tones flat (Tartini)"),

  /// Reversed flat and flat (three-quarter-tones flat) (Zimmermann).
  accidentalThreeQuarterTonesFlatZimmermann("U+E281", null,
      "Reversed flat and flat (three-quarter-tones flat) (Zimmermann)"),

  /// Arabic three-quarter-tones sharp.
  accidentalThreeQuarterTonesSharpArabic(
      "U+ED37", null, "Arabic three-quarter-tones sharp"),

  /// Three-quarter-tones sharp.
  accidentalThreeQuarterTonesSharpArrowDown(
      "U+E277", null, "Three-quarter-tones sharp"),

  /// Three-quarter-tones sharp.
  accidentalThreeQuarterTonesSharpArrowUp(
      "U+E274", "U+1D130", "Three-quarter-tones sharp"),

  /// Three quarter tones sharp (Bussotti).
  accidentalThreeQuarterTonesSharpBusotti(
      "U+E474", null, "Three quarter tones sharp (Bussotti)"),

  /// One and a half sharps (three-quarter-tones sharp) (Stein).
  accidentalThreeQuarterTonesSharpStein("U+E283", null,
      "One and a half sharps (three-quarter-tones sharp) (Stein)"),

  /// Three-quarter-tones sharp (Stockhausen).
  accidentalThreeQuarterTonesSharpStockhausen(
      "U+ED5A", null, "Three-quarter-tones sharp (Stockhausen)"),

  /// Triple flat.
  accidentalTripleFlat("U+E266", null, "Triple flat"),

  /// Triple sharp.
  accidentalTripleSharp("U+E265", null, "Triple sharp"),

  /// Two-third-tones flat (Ferneyhough).
  accidentalTwoThirdTonesFlatFerneyhough(
      "U+E48D", null, "Two-third-tones flat (Ferneyhough)"),

  /// Two-third-tones sharp (Ferneyhough).
  accidentalTwoThirdTonesSharpFerneyhough(
      "U+E48C", null, "Two-third-tones sharp (Ferneyhough)"),

  /// Accidental down.
  accidentalUpsAndDownsDown("U+EE61", null, "Accidental down"),

  /// Accidental less.
  accidentalUpsAndDownsLess("U+EE63", null, "Accidental less"),

  /// Accidental more.
  accidentalUpsAndDownsMore("U+EE62", null, "Accidental more"),

  /// Accidental up.
  accidentalUpsAndDownsUp("U+EE60", null, "Accidental up"),

  /// Wilson minus (5 comma down).
  accidentalWilsonMinus("U+E47C", null, "Wilson minus (5 comma down)"),

  /// Wilson plus (5 comma up).
  accidentalWilsonPlus("U+E47B", null, "Wilson plus (5 comma up)"),

  /// 5/6 tone flat.
  accidentalWyschnegradsky10TwelfthsFlat("U+E434", null, "5/6 tone flat"),

  /// 5/6 tone sharp.
  accidentalWyschnegradsky10TwelfthsSharp("U+E429", null, "5/6 tone sharp"),

  /// 11/12 tone flat.
  accidentalWyschnegradsky11TwelfthsFlat("U+E435", null, "11/12 tone flat"),

  /// 11/12 tone sharp.
  accidentalWyschnegradsky11TwelfthsSharp("U+E42A", null, "11/12 tone sharp"),

  /// 1/12 tone flat.
  accidentalWyschnegradsky1TwelfthsFlat("U+E42B", null, "1/12 tone flat"),

  /// 1/12 tone sharp.
  accidentalWyschnegradsky1TwelfthsSharp("U+E420", null, "1/12 tone sharp"),

  /// 1/6 tone flat.
  accidentalWyschnegradsky2TwelfthsFlat("U+E42C", null, "1/6 tone flat"),

  /// 1/6 tone sharp.
  accidentalWyschnegradsky2TwelfthsSharp("U+E421", null, "1/6 tone sharp"),

  /// 1/4 tone flat.
  accidentalWyschnegradsky3TwelfthsFlat("U+E42D", null, "1/4 tone flat"),

  /// 1/4 tone sharp.
  accidentalWyschnegradsky3TwelfthsSharp("U+E422", null, "1/4 tone sharp"),

  /// 1/3 tone flat.
  accidentalWyschnegradsky4TwelfthsFlat("U+E42E", null, "1/3 tone flat"),

  /// 1/3 tone sharp.
  accidentalWyschnegradsky4TwelfthsSharp("U+E423", null, "1/3 tone sharp"),

  /// 5/12 tone flat.
  accidentalWyschnegradsky5TwelfthsFlat("U+E42F", null, "5/12 tone flat"),

  /// 5/12 tone sharp.
  accidentalWyschnegradsky5TwelfthsSharp("U+E424", null, "5/12 tone sharp"),

  /// 1/2 tone flat.
  accidentalWyschnegradsky6TwelfthsFlat("U+E430", null, "1/2 tone flat"),

  /// 1/2 tone sharp.
  accidentalWyschnegradsky6TwelfthsSharp("U+E425", null, "1/2 tone sharp"),

  /// 7/12 tone flat.
  accidentalWyschnegradsky7TwelfthsFlat("U+E431", null, "7/12 tone flat"),

  /// 7/12 tone sharp.
  accidentalWyschnegradsky7TwelfthsSharp("U+E426", null, "7/12 tone sharp"),

  /// 2/3 tone flat.
  accidentalWyschnegradsky8TwelfthsFlat("U+E432", null, "2/3 tone flat"),

  /// 2/3 tone sharp.
  accidentalWyschnegradsky8TwelfthsSharp("U+E427", null, "2/3 tone sharp"),

  /// 3/4 tone flat.
  accidentalWyschnegradsky9TwelfthsFlat("U+E433", null, "3/4 tone flat"),

  /// 3/4 tone sharp.
  accidentalWyschnegradsky9TwelfthsSharp("U+E428", null, "3/4 tone sharp"),

  /// One-third-tone sharp (Xenakis).
  accidentalXenakisOneThirdToneSharp(
      "U+E470", null, "One-third-tone sharp (Xenakis)"),

  /// Two-third-tones sharp (Xenakis).
  accidentalXenakisTwoThirdTonesSharp(
      "U+E471", null, "Two-third-tones sharp (Xenakis)"),

  /// Choralmelodie (Berg).
  analyticsChoralmelodie("U+E86A", null, "Choralmelodie (Berg)"),

  /// End of stimme.
  analyticsEndStimme("U+E863", "U+1D1A8", "End of stimme"),

  /// Hauptrhythmus (Berg).
  analyticsHauptrhythmus("U+E86B", null, "Hauptrhythmus (Berg)"),

  /// Hauptstimme.
  analyticsHauptstimme("U+E860", "U+1D1A6", "Hauptstimme"),

  /// Inversion 1.
  analyticsInversion1("U+E869", null, "Inversion 1"),

  /// Nebenstimme.
  analyticsNebenstimme("U+E861", "U+1D1A7", "Nebenstimme"),

  /// Start of stimme.
  analyticsStartStimme("U+E862", null, "Start of stimme"),

  /// Theme.
  analyticsTheme("U+E864", null, "Theme"),

  /// Theme 1.
  analyticsTheme1("U+E868", null, "Theme 1"),

  /// Inversion of theme.
  analyticsThemeInversion("U+E867", null, "Inversion of theme"),

  /// Retrograde of theme.
  analyticsThemeRetrograde("U+E865", null, "Retrograde of theme"),

  /// Retrograde inversion of theme.
  analyticsThemeRetrogradeInversion(
      "U+E866", null, "Retrograde inversion of theme"),

  /// Arpeggiato.
  arpeggiato("U+E63C", null, "Arpeggiato"),

  /// Arpeggiato down.
  arpeggiatoDown("U+E635", "U+1D184", "Arpeggiato down"),

  /// Arpeggiato up.
  arpeggiatoUp("U+E634", "U+1D183", "Arpeggiato up"),

  /// Black arrow down (S).
  arrowBlackDown("U+EB64", null, "Black arrow down (S)"),

  /// Black arrow down-left (SW).
  arrowBlackDownLeft("U+EB65", null, "Black arrow down-left (SW)"),

  /// Black arrow down-right (SE).
  arrowBlackDownRight("U+EB63", null, "Black arrow down-right (SE)"),

  /// Black arrow left (W).
  arrowBlackLeft("U+EB66", null, "Black arrow left (W)"),

  /// Black arrow right (E).
  arrowBlackRight("U+EB62", null, "Black arrow right (E)"),

  /// Black arrow up (N).
  arrowBlackUp("U+EB60", null, "Black arrow up (N)"),

  /// Black arrow up-left (NW).
  arrowBlackUpLeft("U+EB67", null, "Black arrow up-left (NW)"),

  /// Black arrow up-right (NE).
  arrowBlackUpRight("U+EB61", null, "Black arrow up-right (NE)"),

  /// Open arrow down (S).
  arrowOpenDown("U+EB74", null, "Open arrow down (S)"),

  /// Open arrow down-left (SW).
  arrowOpenDownLeft("U+EB75", null, "Open arrow down-left (SW)"),

  /// Open arrow down-right (SE).
  arrowOpenDownRight("U+EB73", null, "Open arrow down-right (SE)"),

  /// Open arrow left (W).
  arrowOpenLeft("U+EB76", null, "Open arrow left (W)"),

  /// Open arrow right (E).
  arrowOpenRight("U+EB72", null, "Open arrow right (E)"),

  /// Open arrow up (N).
  arrowOpenUp("U+EB70", null, "Open arrow up (N)"),

  /// Open arrow up-left (NW).
  arrowOpenUpLeft("U+EB77", null, "Open arrow up-left (NW)"),

  /// Open arrow up-right (NE).
  arrowOpenUpRight("U+EB71", null, "Open arrow up-right (NE)"),

  /// White arrow down (S).
  arrowWhiteDown("U+EB6C", null, "White arrow down (S)"),

  /// White arrow down-left (SW).
  arrowWhiteDownLeft("U+EB6D", null, "White arrow down-left (SW)"),

  /// White arrow down-right (SE).
  arrowWhiteDownRight("U+EB6B", null, "White arrow down-right (SE)"),

  /// White arrow left (W).
  arrowWhiteLeft("U+EB6E", null, "White arrow left (W)"),

  /// White arrow right (E).
  arrowWhiteRight("U+EB6A", null, "White arrow right (E)"),

  /// White arrow up (N).
  arrowWhiteUp("U+EB68", null, "White arrow up (N)"),

  /// White arrow up-left (NW).
  arrowWhiteUpLeft("U+EB6F", null, "White arrow up-left (NW)"),

  /// White arrow up-right (NE).
  arrowWhiteUpRight("U+EB69", null, "White arrow up-right (NE)"),

  /// Black arrowhead down (S).
  arrowheadBlackDown("U+EB7C", null, "Black arrowhead down (S)"),

  /// Black arrowhead down-left (SW).
  arrowheadBlackDownLeft("U+EB7D", null, "Black arrowhead down-left (SW)"),

  /// Black arrowhead down-right (SE).
  arrowheadBlackDownRight("U+EB7B", null, "Black arrowhead down-right (SE)"),

  /// Black arrowhead left (W).
  arrowheadBlackLeft("U+EB7E", null, "Black arrowhead left (W)"),

  /// Black arrowhead right (E).
  arrowheadBlackRight("U+EB7A", null, "Black arrowhead right (E)"),

  /// Black arrowhead up (N).
  arrowheadBlackUp("U+EB78", null, "Black arrowhead up (N)"),

  /// Black arrowhead up-left (NW).
  arrowheadBlackUpLeft("U+EB7F", null, "Black arrowhead up-left (NW)"),

  /// Black arrowhead up-right (NE).
  arrowheadBlackUpRight("U+EB79", null, "Black arrowhead up-right (NE)"),

  /// Open arrowhead down (S).
  arrowheadOpenDown("U+EB8C", null, "Open arrowhead down (S)"),

  /// Open arrowhead down-left (SW).
  arrowheadOpenDownLeft("U+EB8D", null, "Open arrowhead down-left (SW)"),

  /// Open arrowhead down-right (SE).
  arrowheadOpenDownRight("U+EB8B", null, "Open arrowhead down-right (SE)"),

  /// Open arrowhead left (W).
  arrowheadOpenLeft("U+EB8E", null, "Open arrowhead left (W)"),

  /// Open arrowhead right (E).
  arrowheadOpenRight("U+EB8A", null, "Open arrowhead right (E)"),

  /// Open arrowhead up (N).
  arrowheadOpenUp("U+EB88", null, "Open arrowhead up (N)"),

  /// Open arrowhead up-left (NW).
  arrowheadOpenUpLeft("U+EB8F", null, "Open arrowhead up-left (NW)"),

  /// Open arrowhead up-right (NE).
  arrowheadOpenUpRight("U+EB89", null, "Open arrowhead up-right (NE)"),

  /// White arrowhead down (S).
  arrowheadWhiteDown("U+EB84", null, "White arrowhead down (S)"),

  /// White arrowhead down-left (SW).
  arrowheadWhiteDownLeft("U+EB85", null, "White arrowhead down-left (SW)"),

  /// White arrowhead down-right (SE).
  arrowheadWhiteDownRight("U+EB83", null, "White arrowhead down-right (SE)"),

  /// White arrowhead left (W).
  arrowheadWhiteLeft("U+EB86", null, "White arrowhead left (W)"),

  /// White arrowhead right (E).
  arrowheadWhiteRight("U+EB82", null, "White arrowhead right (E)"),

  /// White arrowhead up (N).
  arrowheadWhiteUp("U+EB80", null, "White arrowhead up (N)"),

  /// White arrowhead up-left (NW).
  arrowheadWhiteUpLeft("U+EB87", null, "White arrowhead up-left (NW)"),

  /// White arrowhead up-right (NE).
  arrowheadWhiteUpRight("U+EB81", null, "White arrowhead up-right (NE)"),

  /// Accent above.
  articAccentAbove("U+E4A0", "U+1D17B", "Accent above"),

  /// Accent below.
  articAccentBelow("U+E4A1", null, "Accent below"),

  /// Accent-staccato above.
  articAccentStaccatoAbove("U+E4B0", "U+1D181", "Accent-staccato above"),

  /// Accent-staccato below.
  articAccentStaccatoBelow("U+E4B1", null, "Accent-staccato below"),

  /// Laissez vibrer (l.v.) above.
  articLaissezVibrerAbove("U+E4BA", null, "Laissez vibrer (l.v.) above"),

  /// Laissez vibrer (l.v.) below.
  articLaissezVibrerBelow("U+E4BB", null, "Laissez vibrer (l.v.) below"),

  /// Marcato above.
  articMarcatoAbove("U+E4AC", "U+1D17F", "Marcato above"),

  /// Marcato below.
  articMarcatoBelow("U+E4AD", null, "Marcato below"),

  /// Marcato-staccato above.
  articMarcatoStaccatoAbove("U+E4AE", "U+1D180", "Marcato-staccato above"),

  /// Marcato-staccato below.
  articMarcatoStaccatoBelow("U+E4AF", null, "Marcato-staccato below"),

  /// Marcato-tenuto above.
  articMarcatoTenutoAbove("U+E4BC", null, "Marcato-tenuto above"),

  /// Marcato-tenuto below.
  articMarcatoTenutoBelow("U+E4BD", null, "Marcato-tenuto below"),

  /// Soft accent above.
  articSoftAccentAbove("U+ED40", null, "Soft accent above"),

  /// Soft accent below.
  articSoftAccentBelow("U+ED41", null, "Soft accent below"),

  /// Soft accent-staccato above.
  articSoftAccentStaccatoAbove("U+ED42", null, "Soft accent-staccato above"),

  /// Soft accent-staccato below.
  articSoftAccentStaccatoBelow("U+ED43", null, "Soft accent-staccato below"),

  /// Soft accent-tenuto above.
  articSoftAccentTenutoAbove("U+ED44", null, "Soft accent-tenuto above"),

  /// Soft accent-tenuto below.
  articSoftAccentTenutoBelow("U+ED45", null, "Soft accent-tenuto below"),

  /// Soft accent-tenuto-staccato above.
  articSoftAccentTenutoStaccatoAbove(
      "U+ED46", null, "Soft accent-tenuto-staccato above"),

  /// Soft accent-tenuto-staccato below.
  articSoftAccentTenutoStaccatoBelow(
      "U+ED47", null, "Soft accent-tenuto-staccato below"),

  /// Staccatissimo above.
  articStaccatissimoAbove("U+E4A6", "U+1D17E", "Staccatissimo above"),

  /// Staccatissimo below.
  articStaccatissimoBelow("U+E4A7", null, "Staccatissimo below"),

  /// Staccatissimo stroke above.
  articStaccatissimoStrokeAbove("U+E4AA", null, "Staccatissimo stroke above"),

  /// Staccatissimo stroke below.
  articStaccatissimoStrokeBelow("U+E4AB", null, "Staccatissimo stroke below"),

  /// Staccatissimo wedge above.
  articStaccatissimoWedgeAbove("U+E4A8", null, "Staccatissimo wedge above"),

  /// Staccatissimo wedge below.
  articStaccatissimoWedgeBelow("U+E4A9", null, "Staccatissimo wedge below"),

  /// Staccato above.
  articStaccatoAbove("U+E4A2", "U+1D17C", "Staccato above"),

  /// Staccato below.
  articStaccatoBelow("U+E4A3", null, "Staccato below"),

  /// Stress above.
  articStressAbove("U+E4B6", null, "Stress above"),

  /// Stress below.
  articStressBelow("U+E4B7", null, "Stress below"),

  /// Tenuto above.
  articTenutoAbove("U+E4A4", "U+1D17D", "Tenuto above"),

  /// Tenuto-accent above.
  articTenutoAccentAbove("U+E4B4", null, "Tenuto-accent above"),

  /// Tenuto-accent below.
  articTenutoAccentBelow("U+E4B5", null, "Tenuto-accent below"),

  /// Tenuto below.
  articTenutoBelow("U+E4A5", null, "Tenuto below"),

  /// Louré (tenuto-staccato) above.
  articTenutoStaccatoAbove(
      "U+E4B2", "U+1D182", "Louré (tenuto-staccato) above"),

  /// Louré (tenuto-staccato) below.
  articTenutoStaccatoBelow("U+E4B3", null, "Louré (tenuto-staccato) below"),

  /// Unstress above.
  articUnstressAbove("U+E4B8", null, "Unstress above"),

  /// Unstress below.
  articUnstressBelow("U+E4B9", null, "Unstress below"),

  /// Augmentation dot.
  augmentationDot("U+E1E7", "U+1D16D", "Augmentation dot"),

  /// Dashed barline.
  barlineDashed("U+E036", "U+1D104", "Dashed barline"),

  /// Dotted barline.
  barlineDotted("U+E037", null, "Dotted barline"),

  /// Double barline.
  barlineDouble("U+E031", "U+1D101", "Double barline"),

  /// Final barline.
  barlineFinal("U+E032", "U+1D102", "Final barline"),

  /// Heavy barline.
  barlineHeavy("U+E034", null, "Heavy barline"),

  /// Heavy double barline.
  barlineHeavyHeavy("U+E035", null, "Heavy double barline"),

  /// Reverse final barline.
  barlineReverseFinal("U+E033", "U+1D103", "Reverse final barline"),

  /// Short barline.
  barlineShort("U+E038", "U+1D105", "Short barline"),

  /// Single barline.
  barlineSingle("U+E030", "U+1D100", "Single barline"),

  /// Tick barline.
  barlineTick("U+E039", null, "Tick barline"),

  /// Accel./rit. beam 1 (widest).
  beamAccelRit1("U+EAF4", null, "Accel./rit. beam 1 (widest)"),

  /// Accel./rit. beam 10.
  beamAccelRit10("U+EAFD", null, "Accel./rit. beam 10"),

  /// Accel./rit. beam 11.
  beamAccelRit11("U+EAFE", null, "Accel./rit. beam 11"),

  /// Accel./rit. beam 12.
  beamAccelRit12("U+EAFF", null, "Accel./rit. beam 12"),

  /// Accel./rit. beam 13.
  beamAccelRit13("U+EB00", null, "Accel./rit. beam 13"),

  /// Accel./rit. beam 14.
  beamAccelRit14("U+EB01", null, "Accel./rit. beam 14"),

  /// Accel./rit. beam 15 (narrowest).
  beamAccelRit15("U+EB02", null, "Accel./rit. beam 15 (narrowest)"),

  /// Accel./rit. beam 2.
  beamAccelRit2("U+EAF5", null, "Accel./rit. beam 2"),

  /// Accel./rit. beam 3.
  beamAccelRit3("U+EAF6", null, "Accel./rit. beam 3"),

  /// Accel./rit. beam 4.
  beamAccelRit4("U+EAF7", null, "Accel./rit. beam 4"),

  /// Accel./rit. beam 5.
  beamAccelRit5("U+EAF8", null, "Accel./rit. beam 5"),

  /// Accel./rit. beam 6.
  beamAccelRit6("U+EAF9", null, "Accel./rit. beam 6"),

  /// Accel./rit. beam 7.
  beamAccelRit7("U+EAFA", null, "Accel./rit. beam 7"),

  /// Accel./rit. beam 8.
  beamAccelRit8("U+EAFB", null, "Accel./rit. beam 8"),

  /// Accel./rit. beam 9.
  beamAccelRit9("U+EAFC", null, "Accel./rit. beam 9"),

  /// Accel./rit. beam terminating line.
  beamAccelRitFinal("U+EB03", null, "Accel./rit. beam terminating line"),

  /// Brace.
  brace("U+E000", "U+1D114", "Brace"),

  /// Bracket.
  bracket("U+E002", "U+1D115", "Bracket"),

  /// Bracket bottom.
  bracketBottom("U+E004", null, "Bracket bottom"),

  /// Bracket top.
  bracketTop("U+E003", null, "Bracket top"),

  /// Bend.
  brassBend("U+E5E3", "U+1D189", "Bend"),

  /// Doit, long.
  brassDoitLong("U+E5D6", null, "Doit, long"),

  /// Doit, medium.
  brassDoitMedium("U+E5D5", null, "Doit, medium"),

  /// Doit, short.
  brassDoitShort("U+E5D4", "U+1D185", "Doit, short"),

  /// Lip fall, long.
  brassFallLipLong("U+E5D9", null, "Lip fall, long"),

  /// Lip fall, medium.
  brassFallLipMedium("U+E5D8", null, "Lip fall, medium"),

  /// Lip fall, short.
  brassFallLipShort("U+E5D7", "U+1D186", "Lip fall, short"),

  /// Rough fall, long.
  brassFallRoughLong("U+E5DF", null, "Rough fall, long"),

  /// Rough fall, medium.
  brassFallRoughMedium("U+E5DE", null, "Rough fall, medium"),

  /// Rough fall, short.
  brassFallRoughShort("U+E5DD", null, "Rough fall, short"),

  /// Smooth fall, long.
  brassFallSmoothLong("U+E5DC", null, "Smooth fall, long"),

  /// Smooth fall, medium.
  brassFallSmoothMedium("U+E5DB", null, "Smooth fall, medium"),

  /// Smooth fall, short.
  brassFallSmoothShort("U+E5DA", null, "Smooth fall, short"),

  /// Flip.
  brassFlip("U+E5E1", "U+1D187", "Flip"),

  /// Harmon mute, stem in.
  brassHarmonMuteClosed("U+E5E8", null, "Harmon mute, stem in"),

  /// Harmon mute, stem extended, left.
  brassHarmonMuteStemHalfLeft(
      "U+E5E9", null, "Harmon mute, stem extended, left"),

  /// Harmon mute, stem extended, right.
  brassHarmonMuteStemHalfRight(
      "U+E5EA", null, "Harmon mute, stem extended, right"),

  /// Harmon mute, stem out.
  brassHarmonMuteStemOpen("U+E5EB", null, "Harmon mute, stem out"),

  /// Jazz turn.
  brassJazzTurn("U+E5E4", null, "Jazz turn"),

  /// Lift, long.
  brassLiftLong("U+E5D3", null, "Lift, long"),

  /// Lift, medium.
  brassLiftMedium("U+E5D2", null, "Lift, medium"),

  /// Lift, short.
  brassLiftShort("U+E5D1", null, "Lift, short"),

  /// Smooth lift, long.
  brassLiftSmoothLong("U+E5EE", null, "Smooth lift, long"),

  /// Smooth lift, medium.
  brassLiftSmoothMedium("U+E5ED", null, "Smooth lift, medium"),

  /// Smooth lift, short.
  brassLiftSmoothShort("U+E5EC", null, "Smooth lift, short"),

  /// Muted (closed).
  brassMuteClosed("U+E5E5", null, "Muted (closed)"),

  /// Half-muted (half-closed).
  brassMuteHalfClosed("U+E5E6", null, "Half-muted (half-closed)"),

  /// Open.
  brassMuteOpen("U+E5E7", null, "Open"),

  /// Plop.
  brassPlop("U+E5E0", null, "Plop"),

  /// Scoop.
  brassScoop("U+E5D0", null, "Scoop"),

  /// Smear.
  brassSmear("U+E5E2", "U+1D188", "Smear"),

  /// Valve trill.
  brassValveTrill("U+E5EF", null, "Valve trill"),

  /// Breath mark (comma).
  breathMarkComma("U+E4CE", "U+1D112", "Breath mark (comma)"),

  /// Breath mark (Salzedo).
  breathMarkSalzedo("U+E4D5", null, "Breath mark (Salzedo)"),

  /// Breath mark (tick-like).
  breathMarkTick("U+E4CF", null, "Breath mark (tick-like)"),

  /// Breath mark (upbow-like).
  breathMarkUpbow("U+E4D0", null, "Breath mark (upbow-like)"),

  /// Bridge clef.
  bridgeClef("U+E078", null, "Bridge clef"),

  /// Buzz roll.
  buzzRoll("U+E22A", null, "Buzz roll"),

  /// C clef.
  cClef("U+E05C", "U+1D121", "C clef"),

  /// C clef ottava bassa.
  cClef8vb("U+E05D", null, "C clef ottava bassa"),

  /// C clef, arrow down.
  cClefArrowDown("U+E05F", null, "C clef, arrow down"),

  /// C clef, arrow up.
  cClefArrowUp("U+E05E", null, "C clef, arrow up"),

  /// C clef change.
  cClefChange("U+E07B", null, "C clef change"),

  /// Combining C clef.
  cClefCombining("U+E061", null, "Combining C clef"),

  /// Reversed C clef.
  cClefReversed("U+E075", null, "Reversed C clef"),

  /// C clef (19th century).
  cClefSquare("U+E060", null, "C clef (19th century)"),

  /// Caesura.
  caesura("U+E4D1", "U+1D113", "Caesura"),

  /// Curved caesura.
  caesuraCurved("U+E4D4", null, "Curved caesura"),

  /// Short caesura.
  caesuraShort("U+E4D3", null, "Short caesura"),

  /// Single stroke caesura.
  caesuraSingleStroke("U+E4D7", null, "Single stroke caesura"),

  /// Thick caesura.
  caesuraThick("U+E4D2", null, "Thick caesura"),

  /// Accentus above.
  chantAccentusAbove("U+E9D6", null, "Accentus above"),

  /// Accentus below.
  chantAccentusBelow("U+E9D7", null, "Accentus below"),

  /// Punctum auctum, ascending.
  chantAuctumAsc("U+E994", null, "Punctum auctum, ascending"),

  /// Punctum auctum, descending.
  chantAuctumDesc("U+E995", null, "Punctum auctum, descending"),

  /// Augmentum (mora).
  chantAugmentum("U+E9D9", null, "Augmentum (mora)"),

  /// Caesura.
  chantCaesura("U+E8F8", null, "Caesura"),

  /// Plainchant C clef.
  chantCclef("U+E906", "U+1D1D0", "Plainchant C clef"),

  /// Circulus above.
  chantCirculusAbove("U+E9D2", null, "Circulus above"),

  /// Circulus below.
  chantCirculusBelow("U+E9D3", null, "Circulus below"),

  /// Connecting line, ascending 2nd.
  chantConnectingLineAsc2nd("U+E9BD", null, "Connecting line, ascending 2nd"),

  /// Connecting line, ascending 3rd.
  chantConnectingLineAsc3rd("U+E9BE", null, "Connecting line, ascending 3rd"),

  /// Connecting line, ascending 4th.
  chantConnectingLineAsc4th("U+E9BF", null, "Connecting line, ascending 4th"),

  /// Connecting line, ascending 5th.
  chantConnectingLineAsc5th("U+E9C0", null, "Connecting line, ascending 5th"),

  /// Connecting line, ascending 6th.
  chantConnectingLineAsc6th("U+E9C1", null, "Connecting line, ascending 6th"),

  /// Plainchant custos, stem down, high position.
  chantCustosStemDownPosHigh(
      "U+EA08", null, "Plainchant custos, stem down, high position"),

  /// Plainchant custos, stem down, highest position.
  chantCustosStemDownPosHighest(
      "U+EA09", null, "Plainchant custos, stem down, highest position"),

  /// Plainchant custos, stem down, middle position.
  chantCustosStemDownPosMiddle(
      "U+EA07", null, "Plainchant custos, stem down, middle position"),

  /// Plainchant custos, stem up, low position.
  chantCustosStemUpPosLow(
      "U+EA05", null, "Plainchant custos, stem up, low position"),

  /// Plainchant custos, stem up, lowest position.
  chantCustosStemUpPosLowest(
      "U+EA04", null, "Plainchant custos, stem up, lowest position"),

  /// Plainchant custos, stem up, middle position.
  chantCustosStemUpPosMiddle(
      "U+EA06", null, "Plainchant custos, stem up, middle position"),

  /// Punctum deminutum, lower.
  chantDeminutumLower("U+E9B3", null, "Punctum deminutum, lower"),

  /// Punctum deminutum, upper.
  chantDeminutumUpper("U+E9B2", null, "Punctum deminutum, upper"),

  /// Divisio finalis.
  chantDivisioFinalis("U+E8F6", null, "Divisio finalis"),

  /// Divisio maior.
  chantDivisioMaior("U+E8F4", null, "Divisio maior"),

  /// Divisio maxima.
  chantDivisioMaxima("U+E8F5", null, "Divisio maxima"),

  /// Divisio minima.
  chantDivisioMinima("U+E8F3", null, "Divisio minima"),

  /// Entry line, ascending 2nd.
  chantEntryLineAsc2nd("U+E9B4", null, "Entry line, ascending 2nd"),

  /// Entry line, ascending 3rd.
  chantEntryLineAsc3rd("U+E9B5", null, "Entry line, ascending 3rd"),

  /// Entry line, ascending 4th.
  chantEntryLineAsc4th("U+E9B6", null, "Entry line, ascending 4th"),

  /// Entry line, ascending 5th.
  chantEntryLineAsc5th("U+E9B7", null, "Entry line, ascending 5th"),

  /// Entry line, ascending 6th.
  chantEntryLineAsc6th("U+E9B8", null, "Entry line, ascending 6th"),

  /// Episema.
  chantEpisema("U+E9D8", null, "Episema"),

  /// Plainchant F clef.
  chantFclef("U+E902", "U+1D1D1", "Plainchant F clef"),

  /// Ictus above.
  chantIctusAbove("U+E9D0", null, "Ictus above"),

  /// Ictus below.
  chantIctusBelow("U+E9D1", null, "Ictus below"),

  /// Ligated stroke, descending 2nd.
  chantLigaturaDesc2nd("U+E9B9", null, "Ligated stroke, descending 2nd"),

  /// Ligated stroke, descending 3rd.
  chantLigaturaDesc3rd("U+E9BA", null, "Ligated stroke, descending 3rd"),

  /// Ligated stroke, descending 4th.
  chantLigaturaDesc4th("U+E9BB", null, "Ligated stroke, descending 4th"),

  /// Ligated stroke, descending 5th.
  chantLigaturaDesc5th("U+E9BC", null, "Ligated stroke, descending 5th"),

  /// Oriscus ascending.
  chantOriscusAscending("U+E99C", null, "Oriscus ascending"),

  /// Oriscus descending.
  chantOriscusDescending("U+E99D", null, "Oriscus descending"),

  /// Oriscus liquescens.
  chantOriscusLiquescens("U+E99E", null, "Oriscus liquescens"),

  /// Podatus, lower.
  chantPodatusLower("U+E9B0", null, "Podatus, lower"),

  /// Podatus, upper.
  chantPodatusUpper("U+E9B1", "U+1D1D4", "Podatus, upper"),

  /// Punctum.
  chantPunctum("U+E990", null, "Punctum"),

  /// Punctum cavum.
  chantPunctumCavum("U+E998", null, "Punctum cavum"),

  /// Punctum deminutum.
  chantPunctumDeminutum("U+E9A1", null, "Punctum deminutum"),

  /// Punctum inclinatum.
  chantPunctumInclinatum("U+E991", null, "Punctum inclinatum"),

  /// Punctum inclinatum auctum.
  chantPunctumInclinatumAuctum("U+E992", null, "Punctum inclinatum auctum"),

  /// Punctum inclinatum deminutum.
  chantPunctumInclinatumDeminutum(
      "U+E993", null, "Punctum inclinatum deminutum"),

  /// Punctum linea.
  chantPunctumLinea("U+E999", null, "Punctum linea"),

  /// Punctum linea cavum.
  chantPunctumLineaCavum("U+E99A", null, "Punctum linea cavum"),

  /// Punctum virga.
  chantPunctumVirga("U+E996", "U+1D1D3", "Punctum virga"),

  /// Punctum virga, reversed.
  chantPunctumVirgaReversed("U+E997", null, "Punctum virga, reversed"),

  /// Quilisma.
  chantQuilisma("U+E99B", null, "Quilisma"),

  /// Semicirculus above.
  chantSemicirculusAbove("U+E9D4", null, "Semicirculus above"),

  /// Semicirculus below.
  chantSemicirculusBelow("U+E9D5", null, "Semicirculus below"),

  /// Plainchant staff.
  chantStaff("U+E8F0", null, "Plainchant staff"),

  /// Plainchant staff (narrow).
  chantStaffNarrow("U+E8F2", null, "Plainchant staff (narrow)"),

  /// Plainchant staff (wide).
  chantStaffWide("U+E8F1", null, "Plainchant staff (wide)"),

  /// Strophicus.
  chantStrophicus("U+E99F", null, "Strophicus"),

  /// Strophicus auctus.
  chantStrophicusAuctus("U+E9A0", null, "Strophicus auctus"),

  /// Strophicus liquescens, 2nd.
  chantStrophicusLiquescens2nd("U+E9C2", null, "Strophicus liquescens, 2nd"),

  /// Strophicus liquescens, 3rd.
  chantStrophicusLiquescens3rd("U+E9C3", null, "Strophicus liquescens, 3rd"),

  /// Strophicus liquescens, 4th.
  chantStrophicusLiquescens4th("U+E9C4", null, "Strophicus liquescens, 4th"),

  /// Strophicus liquescens, 5th.
  chantStrophicusLiquescens5th("U+E9C5", null, "Strophicus liquescens, 5th"),

  /// Virgula.
  chantVirgula("U+E8F7", null, "Virgula"),

  /// 15 for clefs.
  clef15("U+E07E", null, "15 for clefs"),

  /// 8 for clefs.
  clef8("U+E07D", null, "8 for clefs"),

  /// Combining clef change.
  clefChangeCombining("U+E07F", null, "Combining clef change"),

  /// Coda.
  coda("U+E048", "U+1D10C", "Coda"),

  /// Square coda.
  codaSquare("U+E049", null, "Square coda"),

  /// Beat 2, compound time.
  conductorBeat2Compound("U+E897", null, "Beat 2, compound time"),

  /// Beat 2, simple time.
  conductorBeat2Simple("U+E894", null, "Beat 2, simple time"),

  /// Beat 3, compound time.
  conductorBeat3Compound("U+E898", null, "Beat 3, compound time"),

  /// Beat 3, simple time.
  conductorBeat3Simple("U+E895", null, "Beat 3, simple time"),

  /// Beat 4, compound time.
  conductorBeat4Compound("U+E899", null, "Beat 4, compound time"),

  /// Beat 4, simple time.
  conductorBeat4Simple("U+E896", null, "Beat 4, simple time"),

  /// Left-hand beat or cue.
  conductorLeftBeat("U+E891", null, "Left-hand beat or cue"),

  /// Right-hand beat or cue.
  conductorRightBeat("U+E892", null, "Right-hand beat or cue"),

  /// Strong beat or cue.
  conductorStrongBeat("U+E890", null, "Strong beat or cue"),

  /// Unconducted/free passages.
  conductorUnconducted("U+E89A", null, "Unconducted/free passages"),

  /// Weak beat or cue.
  conductorWeakBeat("U+E893", null, "Weak beat or cue"),

  /// Begin beam.
  controlBeginBeam("U+E8E0", "U+1D173", "Begin beam"),

  /// Begin phrase.
  controlBeginPhrase("U+E8E6", "U+1D179", "Begin phrase"),

  /// Begin slur.
  controlBeginSlur("U+E8E4", "U+1D177", "Begin slur"),

  /// Begin tie.
  controlBeginTie("U+E8E2", "U+1D175", "Begin tie"),

  /// End beam.
  controlEndBeam("U+E8E1", "U+1D174", "End beam"),

  /// End phrase.
  controlEndPhrase("U+E8E7", "U+1D17A", "End phrase"),

  /// End slur.
  controlEndSlur("U+E8E5", "U+1D178", "End slur"),

  /// End tie.
  controlEndTie("U+E8E3", "U+1D176", "End tie"),

  /// Double flat.
  csymAccidentalDoubleFlat("U+ED64", null, "Double flat"),

  /// Double sharp.
  csymAccidentalDoubleSharp("U+ED63", null, "Double sharp"),

  /// Flat.
  csymAccidentalFlat("U+ED60", null, "Flat"),

  /// Natural.
  csymAccidentalNatural("U+ED61", null, "Natural"),

  /// Sharp.
  csymAccidentalSharp("U+ED62", null, "Sharp"),

  /// Triple flat.
  csymAccidentalTripleFlat("U+ED66", null, "Triple flat"),

  /// Triple sharp.
  csymAccidentalTripleSharp("U+ED65", null, "Triple sharp"),

  /// Slash for altered bass note.
  csymAlteredBassSlash("U+E87B", null, "Slash for altered bass note"),

  /// Augmented.
  csymAugmented("U+E872", null, "Augmented"),

  /// Double-height left bracket.
  csymBracketLeftTall("U+E877", null, "Double-height left bracket"),

  /// Double-height right bracket.
  csymBracketRightTall("U+E878", null, "Double-height right bracket"),

  /// Slash for chord symbols arranged diagonally.
  csymDiagonalArrangementSlash(
      "U+E87C", null, "Slash for chord symbols arranged diagonally"),

  /// Diminished.
  csymDiminished("U+E870", "U+1D1A9", "Diminished"),

  /// Half-diminished.
  csymHalfDiminished("U+E871", null, "Half-diminished"),

  /// Major seventh.
  csymMajorSeventh("U+E873", null, "Major seventh"),

  /// Minor.
  csymMinor("U+E874", null, "Minor"),

  /// Double-height left parenthesis.
  csymParensLeftTall("U+E875", null, "Double-height left parenthesis"),

  /// Triple-height left parenthesis.
  csymParensLeftVeryTall("U+E879", null, "Triple-height left parenthesis"),

  /// Double-height right parenthesis.
  csymParensRightTall("U+E876", null, "Double-height right parenthesis"),

  /// Triple-height right parenthesis.
  csymParensRightVeryTall("U+E87A", null, "Triple-height right parenthesis"),

  /// Curlew (Britten).
  curlewSign("U+E4D6", null, "Curlew (Britten)"),

  /// Da capo.
  daCapo("U+E046", "U+1D10A", "Da capo"),

  /// Dal segno.
  dalSegno("U+E045", "U+1D109", "Dal segno"),

  /// Daseian excellentes 1.
  daseianExcellentes1("U+EA3C", null, "Daseian excellentes 1"),

  /// Daseian excellentes 2.
  daseianExcellentes2("U+EA3D", null, "Daseian excellentes 2"),

  /// Daseian excellentes 3.
  daseianExcellentes3("U+EA3E", null, "Daseian excellentes 3"),

  /// Daseian excellentes 4.
  daseianExcellentes4("U+EA3F", null, "Daseian excellentes 4"),

  /// Daseian finales 1.
  daseianFinales1("U+EA34", null, "Daseian finales 1"),

  /// Daseian finales 2.
  daseianFinales2("U+EA35", null, "Daseian finales 2"),

  /// Daseian finales 3.
  daseianFinales3("U+EA36", null, "Daseian finales 3"),

  /// Daseian finales 4.
  daseianFinales4("U+EA37", null, "Daseian finales 4"),

  /// Daseian graves 1.
  daseianGraves1("U+EA30", null, "Daseian graves 1"),

  /// Daseian graves 2.
  daseianGraves2("U+EA31", null, "Daseian graves 2"),

  /// Daseian graves 3.
  daseianGraves3("U+EA32", null, "Daseian graves 3"),

  /// Daseian graves 4.
  daseianGraves4("U+EA33", null, "Daseian graves 4"),

  /// Daseian residua 1.
  daseianResidua1("U+EA40", null, "Daseian residua 1"),

  /// Daseian residua 2.
  daseianResidua2("U+EA41", null, "Daseian residua 2"),

  /// Daseian superiores 1.
  daseianSuperiores1("U+EA38", null, "Daseian superiores 1"),

  /// Daseian superiores 2.
  daseianSuperiores2("U+EA39", null, "Daseian superiores 2"),

  /// Daseian superiores 3.
  daseianSuperiores3("U+EA3A", null, "Daseian superiores 3"),

  /// Daseian superiores 4.
  daseianSuperiores4("U+EA3B", null, "Daseian superiores 4"),

  /// Double lateral roll (Stevens).
  doubleLateralRollStevens("U+E234", null, "Double lateral roll (Stevens)"),

  /// Double-tongue above.
  doubleTongueAbove("U+E5F0", "U+1D18A", "Double-tongue above"),

  /// Double-tongue below.
  doubleTongueBelow("U+E5F1", null, "Double-tongue below"),

  /// Colon separator for combined dynamics.
  dynamicCombinedSeparatorColon(
      "U+E546", null, "Colon separator for combined dynamics"),

  /// Hyphen separator for combined dynamics.
  dynamicCombinedSeparatorHyphen(
      "U+E547", null, "Hyphen separator for combined dynamics"),

  /// Slash separator for combined dynamics.
  dynamicCombinedSeparatorSlash(
      "U+E549", null, "Slash separator for combined dynamics"),

  /// Space separator for combined dynamics.
  dynamicCombinedSeparatorSpace(
      "U+E548", null, "Space separator for combined dynamics"),

  /// Crescendo.
  dynamicCrescendoHairpin("U+E53E", "U+1D192", "Crescendo"),

  /// Diminuendo.
  dynamicDiminuendoHairpin("U+E53F", "U+1D193", "Diminuendo"),

  /// ff.
  dynamicFF("U+E52F", null, "ff"),

  /// fff.
  dynamicFFF("U+E530", null, "fff"),

  /// ffff.
  dynamicFFFF("U+E531", null, "ffff"),

  /// fffff.
  dynamicFFFFF("U+E532", null, "fffff"),

  /// ffffff.
  dynamicFFFFFF("U+E533", null, "ffffff"),

  /// Forte.
  dynamicForte("U+E522", "U+1D191", "Forte"),

  /// Forte-piano.
  dynamicFortePiano("U+E534", null, "Forte-piano"),

  /// Forzando.
  dynamicForzando("U+E535", null, "Forzando"),

  /// Left bracket (for hairpins).
  dynamicHairpinBracketLeft("U+E544", null, "Left bracket (for hairpins)"),

  /// Right bracket (for hairpins).
  dynamicHairpinBracketRight("U+E545", null, "Right bracket (for hairpins)"),

  /// Left parenthesis (for hairpins).
  dynamicHairpinParenthesisLeft(
      "U+E542", null, "Left parenthesis (for hairpins)"),

  /// Right parenthesis (for hairpins).
  dynamicHairpinParenthesisRight(
      "U+E543", null, "Right parenthesis (for hairpins)"),

  /// mf.
  dynamicMF("U+E52D", null, "mf"),

  /// mp.
  dynamicMP("U+E52C", null, "mp"),

  /// Messa di voce.
  dynamicMessaDiVoce("U+E540", null, "Messa di voce"),

  /// Mezzo.
  dynamicMezzo("U+E521", "U+1D190", "Mezzo"),

  /// Niente.
  dynamicNiente("U+E526", null, "Niente"),

  /// Niente (for hairpins).
  dynamicNienteForHairpin("U+E541", null, "Niente (for hairpins)"),

  /// pf.
  dynamicPF("U+E52E", null, "pf"),

  /// pp.
  dynamicPP("U+E52B", null, "pp"),

  /// ppp.
  dynamicPPP("U+E52A", null, "ppp"),

  /// pppp.
  dynamicPPPP("U+E529", null, "pppp"),

  /// ppppp.
  dynamicPPPPP("U+E528", null, "ppppp"),

  /// pppppp.
  dynamicPPPPPP("U+E527", null, "pppppp"),

  /// Piano.
  dynamicPiano("U+E520", "U+1D18F", "Piano"),

  /// Rinforzando.
  dynamicRinforzando("U+E523", "U+1D18C", "Rinforzando"),

  /// Rinforzando 1.
  dynamicRinforzando1("U+E53C", null, "Rinforzando 1"),

  /// Rinforzando 2.
  dynamicRinforzando2("U+E53D", null, "Rinforzando 2"),

  /// Sforzando.
  dynamicSforzando("U+E524", "U+1D18D", "Sforzando"),

  /// Sforzando 1.
  dynamicSforzando1("U+E536", null, "Sforzando 1"),

  /// Sforzando-pianissimo.
  dynamicSforzandoPianissimo("U+E538", null, "Sforzando-pianissimo"),

  /// Sforzando-piano.
  dynamicSforzandoPiano("U+E537", null, "Sforzando-piano"),

  /// Sforzato.
  dynamicSforzato("U+E539", null, "Sforzato"),

  /// Sforzatissimo.
  dynamicSforzatoFF("U+E53B", null, "Sforzatissimo"),

  /// Sforzato-piano.
  dynamicSforzatoPiano("U+E53A", null, "Sforzato-piano"),

  /// Z.
  dynamicZ("U+E525", "U+1D18E", "Z"),

  /// Eight channels (7.1 surround).
  elecAudioChannelsEight("U+EB46", null, "Eight channels (7.1 surround)"),

  /// Five channels.
  elecAudioChannelsFive("U+EB43", null, "Five channels"),

  /// Four channels.
  elecAudioChannelsFour("U+EB42", null, "Four channels"),

  /// One channel (mono).
  elecAudioChannelsOne("U+EB3E", null, "One channel (mono)"),

  /// Seven channels.
  elecAudioChannelsSeven("U+EB45", null, "Seven channels"),

  /// Six channels (5.1 surround).
  elecAudioChannelsSix("U+EB44", null, "Six channels (5.1 surround)"),

  /// Three channels (frontal).
  elecAudioChannelsThreeFrontal("U+EB40", null, "Three channels (frontal)"),

  /// Three channels (surround).
  elecAudioChannelsThreeSurround("U+EB41", null, "Three channels (surround)"),

  /// Two channels (stereo).
  elecAudioChannelsTwo("U+EB3F", null, "Two channels (stereo)"),

  /// Audio in.
  elecAudioIn("U+EB49", null, "Audio in"),

  /// Mono audio setup.
  elecAudioMono("U+EB3C", null, "Mono audio setup"),

  /// Audio out.
  elecAudioOut("U+EB4A", null, "Audio out"),

  /// Stereo audio setup.
  elecAudioStereo("U+EB3D", null, "Stereo audio setup"),

  /// Camera.
  elecCamera("U+EB1B", null, "Camera"),

  /// Data in.
  elecDataIn("U+EB4D", null, "Data in"),

  /// Data out.
  elecDataOut("U+EB4E", null, "Data out"),

  /// Disc.
  elecDisc("U+EB13", null, "Disc"),

  /// Download.
  elecDownload("U+EB4F", null, "Download"),

  /// Eject.
  elecEject("U+EB2B", null, "Eject"),

  /// Fast-forward.
  elecFastForward("U+EB1F", null, "Fast-forward"),

  /// Headphones.
  elecHeadphones("U+EB11", null, "Headphones"),

  /// Headset.
  elecHeadset("U+EB12", null, "Headset"),

  /// Line in.
  elecLineIn("U+EB47", null, "Line in"),

  /// Line out.
  elecLineOut("U+EB48", null, "Line out"),

  /// Loop.
  elecLoop("U+EB23", null, "Loop"),

  /// Loudspeaker.
  elecLoudspeaker("U+EB1A", null, "Loudspeaker"),

  /// MIDI controller 0%.
  elecMIDIController0("U+EB36", null, "MIDI controller 0%"),

  /// MIDI controller 100%.
  elecMIDIController100("U+EB3B", null, "MIDI controller 100%"),

  /// MIDI controller 20%.
  elecMIDIController20("U+EB37", null, "MIDI controller 20%"),

  /// MIDI controller 40%.
  elecMIDIController40("U+EB38", null, "MIDI controller 40%"),

  /// MIDI controller 60%.
  elecMIDIController60("U+EB39", null, "MIDI controller 60%"),

  /// MIDI controller 80%.
  elecMIDIController80("U+EB3A", null, "MIDI controller 80%"),

  /// MIDI in.
  elecMIDIIn("U+EB34", null, "MIDI in"),

  /// MIDI out.
  elecMIDIOut("U+EB35", null, "MIDI out"),

  /// Microphone.
  elecMicrophone("U+EB10", null, "Microphone"),

  /// Mute microphone.
  elecMicrophoneMute("U+EB28", null, "Mute microphone"),

  /// Unmute microphone.
  elecMicrophoneUnmute("U+EB29", null, "Unmute microphone"),

  /// Mixing console.
  elecMixingConsole("U+EB15", null, "Mixing console"),

  /// Monitor.
  elecMonitor("U+EB18", null, "Monitor"),

  /// Mute.
  elecMute("U+EB26", null, "Mute"),

  /// Pause.
  elecPause("U+EB1E", null, "Pause"),

  /// Play.
  elecPlay("U+EB1C", null, "Play"),

  /// Power on/off.
  elecPowerOnOff("U+EB2A", null, "Power on/off"),

  /// Projector.
  elecProjector("U+EB19", null, "Projector"),

  /// Replay.
  elecReplay("U+EB24", null, "Replay"),

  /// Rewind.
  elecRewind("U+EB20", null, "Rewind"),

  /// Shuffle.
  elecShuffle("U+EB25", null, "Shuffle"),

  /// Skip backwards.
  elecSkipBackwards("U+EB22", null, "Skip backwards"),

  /// Skip forwards.
  elecSkipForwards("U+EB21", null, "Skip forwards"),

  /// Stop.
  elecStop("U+EB1D", null, "Stop"),

  /// Tape.
  elecTape("U+EB14", null, "Tape"),

  /// USB connection.
  elecUSB("U+EB16", null, "USB connection"),

  /// Unmute.
  elecUnmute("U+EB27", null, "Unmute"),

  /// Upload.
  elecUpload("U+EB50", null, "Upload"),

  /// Video camera.
  elecVideoCamera("U+EB17", null, "Video camera"),

  /// Video in.
  elecVideoIn("U+EB4B", null, "Video in"),

  /// Video out.
  elecVideoOut("U+EB4C", null, "Video out"),

  /// Combining volume fader.
  elecVolumeFader("U+EB2C", null, "Combining volume fader"),

  /// Combining volume fader thumb.
  elecVolumeFaderThumb("U+EB2D", null, "Combining volume fader thumb"),

  /// Volume level 0%.
  elecVolumeLevel0("U+EB2E", null, "Volume level 0%"),

  /// Volume level 100%.
  elecVolumeLevel100("U+EB33", null, "Volume level 100%"),

  /// Volume level 20%.
  elecVolumeLevel20("U+EB2F", null, "Volume level 20%"),

  /// Volume level 40%.
  elecVolumeLevel40("U+EB30", null, "Volume level 40%"),

  /// Volume level 60%.
  elecVolumeLevel60("U+EB31", null, "Volume level 60%"),

  /// Volume level 80%.
  elecVolumeLevel80("U+EB32", null, "Volume level 80%"),

  /// F clef.
  fClef("U+E062", "U+1D122", "F clef"),

  /// F clef quindicesima alta.
  fClef15ma("U+E066", null, "F clef quindicesima alta"),

  /// F clef quindicesima bassa.
  fClef15mb("U+E063", null, "F clef quindicesima bassa"),

  /// F clef ottava alta.
  fClef8va("U+E065", "U+1D123", "F clef ottava alta"),

  /// F clef ottava bassa.
  fClef8vb("U+E064", "U+1D124", "F clef ottava bassa"),

  /// F clef, arrow down.
  fClefArrowDown("U+E068", null, "F clef, arrow down"),

  /// F clef, arrow up.
  fClefArrowUp("U+E067", null, "F clef, arrow up"),

  /// F clef change.
  fClefChange("U+E07C", null, "F clef change"),

  /// Reversed F clef.
  fClefReversed("U+E076", null, "Reversed F clef"),

  /// Turned F clef.
  fClefTurned("U+E077", null, "Turned F clef"),

  /// Fermata above.
  fermataAbove("U+E4C0", "U+1D110", "Fermata above"),

  /// Fermata below.
  fermataBelow("U+E4C1", "U+1D111", "Fermata below"),

  /// Long fermata above.
  fermataLongAbove("U+E4C6", null, "Long fermata above"),

  /// Long fermata below.
  fermataLongBelow("U+E4C7", null, "Long fermata below"),

  /// Long fermata (Henze) above.
  fermataLongHenzeAbove("U+E4CA", null, "Long fermata (Henze) above"),

  /// Long fermata (Henze) below.
  fermataLongHenzeBelow("U+E4CB", null, "Long fermata (Henze) below"),

  /// Short fermata above.
  fermataShortAbove("U+E4C4", null, "Short fermata above"),

  /// Short fermata below.
  fermataShortBelow("U+E4C5", null, "Short fermata below"),

  /// Short fermata (Henze) above.
  fermataShortHenzeAbove("U+E4CC", null, "Short fermata (Henze) above"),

  /// Short fermata (Henze) below.
  fermataShortHenzeBelow("U+E4CD", null, "Short fermata (Henze) below"),

  /// Very long fermata above.
  fermataVeryLongAbove("U+E4C8", null, "Very long fermata above"),

  /// Very long fermata below.
  fermataVeryLongBelow("U+E4C9", null, "Very long fermata below"),

  /// Very short fermata above.
  fermataVeryShortAbove("U+E4C2", null, "Very short fermata above"),

  /// Very short fermata below.
  fermataVeryShortBelow("U+E4C3", null, "Very short fermata below"),

  /// Figured bass 0.
  figbass0("U+EA50", null, "Figured bass 0"),

  /// Figured bass 1.
  figbass1("U+EA51", null, "Figured bass 1"),

  /// Figured bass 2.
  figbass2("U+EA52", null, "Figured bass 2"),

  /// Figured bass 2 raised by half-step.
  figbass2Raised("U+EA53", null, "Figured bass 2 raised by half-step"),

  /// Figured bass 3.
  figbass3("U+EA54", null, "Figured bass 3"),

  /// Figured bass 4.
  figbass4("U+EA55", null, "Figured bass 4"),

  /// Figured bass 4 raised by half-step.
  figbass4Raised("U+EA56", null, "Figured bass 4 raised by half-step"),

  /// Figured bass 5.
  figbass5("U+EA57", null, "Figured bass 5"),

  /// Figured bass 5 raised by half-step.
  figbass5Raised1("U+EA58", null, "Figured bass 5 raised by half-step"),

  /// Figured bass 5 raised by half-step 2.
  figbass5Raised2("U+EA59", null, "Figured bass 5 raised by half-step 2"),

  /// Figured bass diminished 5.
  figbass5Raised3("U+EA5A", null, "Figured bass diminished 5"),

  /// Figured bass 6.
  figbass6("U+EA5B", null, "Figured bass 6"),

  /// Figured bass 6 raised by half-step.
  figbass6Raised("U+EA5C", null, "Figured bass 6 raised by half-step"),

  /// Figured bass 6 raised by half-step 2.
  figbass6Raised2("U+EA6F", null, "Figured bass 6 raised by half-step 2"),

  /// Figured bass 7.
  figbass7("U+EA5D", null, "Figured bass 7"),

  /// Figured bass 7 diminished.
  figbass7Diminished("U+ECC0", null, "Figured bass 7 diminished"),

  /// Figured bass 7 raised by half-step.
  figbass7Raised1("U+EA5E", null, "Figured bass 7 raised by half-step"),

  /// Figured bass 7 lowered by a half-step.
  figbass7Raised2("U+EA5F", null, "Figured bass 7 lowered by a half-step"),

  /// Figured bass 8.
  figbass8("U+EA60", null, "Figured bass 8"),

  /// Figured bass 9.
  figbass9("U+EA61", null, "Figured bass 9"),

  /// Figured bass 9 raised by half-step.
  figbass9Raised("U+EA62", null, "Figured bass 9 raised by half-step"),

  /// Figured bass [.
  figbassBracketLeft("U+EA68", null, "Figured bass ["),

  /// Figured bass ].
  figbassBracketRight("U+EA69", null, "Figured bass ]"),

  /// Combining lower.
  figbassCombiningLowering("U+EA6E", null, "Combining lower"),

  /// Combining raise.
  figbassCombiningRaising("U+EA6D", null, "Combining raise"),

  /// Figured bass double flat.
  figbassDoubleFlat("U+EA63", null, "Figured bass double flat"),

  /// Figured bass double sharp.
  figbassDoubleSharp("U+EA67", null, "Figured bass double sharp"),

  /// Figured bass flat.
  figbassFlat("U+EA64", null, "Figured bass flat"),

  /// Figured bass natural.
  figbassNatural("U+EA65", null, "Figured bass natural"),

  /// Figured bass (.
  figbassParensLeft("U+EA6A", null, "Figured bass ("),

  /// Figured bass ).
  figbassParensRight("U+EA6B", null, "Figured bass )"),

  /// Figured bass +.
  figbassPlus("U+EA6C", null, "Figured bass +"),

  /// Figured bass sharp.
  figbassSharp("U+EA66", null, "Figured bass sharp"),

  /// Figured bass triple flat.
  figbassTripleFlat("U+ECC1", null, "Figured bass triple flat"),

  /// Figured bass triple sharp.
  figbassTripleSharp("U+ECC2", null, "Figured bass triple sharp"),

  /// Fingering 0 (open string).
  fingering0("U+ED10", null, "Fingering 0 (open string)"),

  /// Fingering 0 italic (open string).
  fingering0Italic("U+ED80", null, "Fingering 0 italic (open string)"),

  /// Fingering 1 (thumb).
  fingering1("U+ED11", null, "Fingering 1 (thumb)"),

  /// Fingering 1 italic (thumb).
  fingering1Italic("U+ED81", null, "Fingering 1 italic (thumb)"),

  /// Fingering 2 (index finger).
  fingering2("U+ED12", null, "Fingering 2 (index finger)"),

  /// Fingering 2 italic (index finger).
  fingering2Italic("U+ED82", null, "Fingering 2 italic (index finger)"),

  /// Fingering 3 (middle finger).
  fingering3("U+ED13", null, "Fingering 3 (middle finger)"),

  /// Fingering 3 italic (middle finger).
  fingering3Italic("U+ED83", null, "Fingering 3 italic (middle finger)"),

  /// Fingering 4 (ring finger).
  fingering4("U+ED14", null, "Fingering 4 (ring finger)"),

  /// Fingering 4 italic (ring finger).
  fingering4Italic("U+ED84", null, "Fingering 4 italic (ring finger)"),

  /// Fingering 5 (little finger).
  fingering5("U+ED15", null, "Fingering 5 (little finger)"),

  /// Fingering 5 italic (little finger).
  fingering5Italic("U+ED85", null, "Fingering 5 italic (little finger)"),

  /// Fingering 6.
  fingering6("U+ED24", null, "Fingering 6"),

  /// Fingering 6 italic.
  fingering6Italic("U+ED86", null, "Fingering 6 italic"),

  /// Fingering 7.
  fingering7("U+ED25", null, "Fingering 7"),

  /// Fingering 7 italic.
  fingering7Italic("U+ED87", null, "Fingering 7 italic"),

  /// Fingering 8.
  fingering8("U+ED26", null, "Fingering 8"),

  /// Fingering 8 italic.
  fingering8Italic("U+ED88", null, "Fingering 8 italic"),

  /// Fingering 9.
  fingering9("U+ED27", null, "Fingering 9"),

  /// Fingering 9 italic.
  fingering9Italic("U+ED89", null, "Fingering 9 italic"),

  /// Fingering a (anular; right-hand ring finger for guitar).
  fingeringALower("U+ED1B", null,
      "Fingering a (anular; right-hand ring finger for guitar)"),

  /// Fingering c (right-hand little finger for guitar).
  fingeringCLower(
      "U+ED1C", null, "Fingering c (right-hand little finger for guitar)"),

  /// Fingering e (right-hand little finger for guitar).
  fingeringELower(
      "U+ED1E", null, "Fingering e (right-hand little finger for guitar)"),

  /// Fingering i (indicio; right-hand index finger for guitar).
  fingeringILower("U+ED19", null,
      "Fingering i (indicio; right-hand index finger for guitar)"),

  /// Fingering left bracket.
  fingeringLeftBracket("U+ED2A", null, "Fingering left bracket"),

  /// Fingering left bracket italic.
  fingeringLeftBracketItalic("U+ED8C", null, "Fingering left bracket italic"),

  /// Fingering left parenthesis.
  fingeringLeftParenthesis("U+ED28", null, "Fingering left parenthesis"),

  /// Fingering left parenthesis italic.
  fingeringLeftParenthesisItalic(
      "U+ED8A", null, "Fingering left parenthesis italic"),

  /// Fingering m (medio; right-hand middle finger for guitar).
  fingeringMLower("U+ED1A", null,
      "Fingering m (medio; right-hand middle finger for guitar)"),

  /// Multiple notes played by thumb or single finger.
  fingeringMultipleNotes(
      "U+ED23", null, "Multiple notes played by thumb or single finger"),

  /// Fingering o (right-hand little finger for guitar).
  fingeringOLower(
      "U+ED1F", null, "Fingering o (right-hand little finger for guitar)"),

  /// Fingering p (pulgar; right-hand thumb for guitar).
  fingeringPLower(
      "U+ED17", null, "Fingering p (pulgar; right-hand thumb for guitar)"),

  /// Fingering q (right-hand little finger for guitar).
  fingeringQLower(
      "U+ED8E", null, "Fingering q (right-hand little finger for guitar)"),

  /// Fingering right bracket.
  fingeringRightBracket("U+ED2B", null, "Fingering right bracket"),

  /// Fingering right bracket italic.
  fingeringRightBracketItalic("U+ED8D", null, "Fingering right bracket italic"),

  /// Fingering right parenthesis.
  fingeringRightParenthesis("U+ED29", null, "Fingering right parenthesis"),

  /// Fingering right parenthesis italic.
  fingeringRightParenthesisItalic(
      "U+ED8B", null, "Fingering right parenthesis italic"),

  /// Fingering s (right-hand little finger for guitar).
  fingeringSLower(
      "U+ED8F", null, "Fingering s (right-hand little finger for guitar)"),

  /// Fingering middle dot separator.
  fingeringSeparatorMiddleDot("U+ED2C", null, "Fingering middle dot separator"),

  /// Fingering white middle dot separator.
  fingeringSeparatorMiddleDotWhite(
      "U+ED2D", null, "Fingering white middle dot separator"),

  /// Fingering forward slash separator.
  fingeringSeparatorSlash("U+ED2E", null, "Fingering forward slash separator"),

  /// Finger substitution above.
  fingeringSubstitutionAbove("U+ED20", null, "Finger substitution above"),

  /// Finger substitution below.
  fingeringSubstitutionBelow("U+ED21", null, "Finger substitution below"),

  /// Finger substitution dash.
  fingeringSubstitutionDash("U+ED22", null, "Finger substitution dash"),

  /// Fingering t (right-hand thumb for guitar).
  fingeringTLower("U+ED18", null, "Fingering t (right-hand thumb for guitar)"),

  /// Fingering T (left-hand thumb for guitar).
  fingeringTUpper("U+ED16", null, "Fingering T (left-hand thumb for guitar)"),

  /// Fingering x (right-hand little finger for guitar).
  fingeringXLower(
      "U+ED1D", null, "Fingering x (right-hand little finger for guitar)"),

  /// Combining flag 8 (1024th) below.
  flag1024thDown("U+E24F", null, "Combining flag 8 (1024th) below"),

  /// Combining flag 8 (1024th) above.
  flag1024thUp("U+E24E", null, "Combining flag 8 (1024th) above"),

  /// Combining flag 5 (128th) below.
  flag128thDown("U+E249", null, "Combining flag 5 (128th) below"),

  /// Combining flag 5 (128th) above.
  flag128thUp("U+E248", "U+1D172", "Combining flag 5 (128th) above"),

  /// Combining flag 2 (16th) below.
  flag16thDown("U+E243", null, "Combining flag 2 (16th) below"),

  /// Combining flag 2 (16th) above.
  flag16thUp("U+E242", "U+1D16F", "Combining flag 2 (16th) above"),

  /// Combining flag 6 (256th) below.
  flag256thDown("U+E24B", null, "Combining flag 6 (256th) below"),

  /// Combining flag 6 (256th) above.
  flag256thUp("U+E24A", null, "Combining flag 6 (256th) above"),

  /// Combining flag 3 (32nd) below.
  flag32ndDown("U+E245", null, "Combining flag 3 (32nd) below"),

  /// Combining flag 3 (32nd) above.
  flag32ndUp("U+E244", "U+1D170", "Combining flag 3 (32nd) above"),

  /// Combining flag 7 (512th) below.
  flag512thDown("U+E24D", null, "Combining flag 7 (512th) below"),

  /// Combining flag 7 (512th) above.
  flag512thUp("U+E24C", null, "Combining flag 7 (512th) above"),

  /// Combining flag 4 (64th) below.
  flag64thDown("U+E247", null, "Combining flag 4 (64th) below"),

  /// Combining flag 4 (64th) above.
  flag64thUp("U+E246", "U+1D171", "Combining flag 4 (64th) above"),

  /// Combining flag 1 (8th) below.
  flag8thDown("U+E241", null, "Combining flag 1 (8th) below"),

  /// Combining flag 1 (8th) above.
  flag8thUp("U+E240", "U+1D16E", "Combining flag 1 (8th) above"),

  /// Internal combining flag below.
  flagInternalDown("U+E251", null, "Internal combining flag below"),

  /// Internal combining flag above.
  flagInternalUp("U+E250", null, "Internal combining flag above"),

  /// 3-string fretboard.
  fretboard3String("U+E850", null, "3-string fretboard"),

  /// 3-string fretboard at nut.
  fretboard3StringNut("U+E851", null, "3-string fretboard at nut"),

  /// 4-string fretboard.
  fretboard4String("U+E852", "U+1D11D", "4-string fretboard"),

  /// 4-string fretboard at nut.
  fretboard4StringNut("U+E853", null, "4-string fretboard at nut"),

  /// 5-string fretboard.
  fretboard5String("U+E854", null, "5-string fretboard"),

  /// 5-string fretboard at nut.
  fretboard5StringNut("U+E855", null, "5-string fretboard at nut"),

  /// 6-string fretboard.
  fretboard6String("U+E856", "U+1D11C", "6-string fretboard"),

  /// 6-string fretboard at nut.
  fretboard6StringNut("U+E857", null, "6-string fretboard at nut"),

  /// Fingered fret (filled circle).
  fretboardFilledCircle("U+E858", null, "Fingered fret (filled circle)"),

  /// Open string (O).
  fretboardO("U+E85A", null, "Open string (O)"),

  /// String not played (X).
  fretboardX("U+E859", null, "String not played (X)"),

  /// Function theory angle bracket left.
  functionAngleLeft("U+EA93", null, "Function theory angle bracket left"),

  /// Function theory angle bracket right.
  functionAngleRight("U+EA94", null, "Function theory angle bracket right"),

  /// Function theory bracket left.
  functionBracketLeft("U+EA8F", null, "Function theory bracket left"),

  /// Function theory bracket right.
  functionBracketRight("U+EA90", null, "Function theory bracket right"),

  /// Function theory dominant of dominant.
  functionDD("U+EA81", null, "Function theory dominant of dominant"),

  /// Function theory minor dominant.
  functionDLower("U+EA80", null, "Function theory minor dominant"),

  /// Function theory major dominant.
  functionDUpper("U+EA7F", null, "Function theory major dominant"),

  /// Function theory 8.
  functionEight("U+EA78", null, "Function theory 8"),

  /// Function theory F.
  functionFUpper("U+EA99", null, "Function theory F"),

  /// Function theory 5.
  functionFive("U+EA75", null, "Function theory 5"),

  /// Function theory 4.
  functionFour("U+EA74", null, "Function theory 4"),

  /// Function theory g.
  functionGLower("U+EA84", null, "Function theory g"),

  /// Function theory G.
  functionGUpper("U+EA83", null, "Function theory G"),

  /// Function theory greater than.
  functionGreaterThan("U+EA7C", null, "Function theory greater than"),

  /// Function theory i.
  functionILower("U+EA9B", null, "Function theory i"),

  /// Function theory I.
  functionIUpper("U+EA9A", null, "Function theory I"),

  /// Function theory k.
  functionKLower("U+EA9D", null, "Function theory k"),

  /// Function theory K.
  functionKUpper("U+EA9C", null, "Function theory K"),

  /// Function theory l.
  functionLLower("U+EA9F", null, "Function theory l"),

  /// Function theory L.
  functionLUpper("U+EA9E", null, "Function theory L"),

  /// Function theory less than.
  functionLessThan("U+EA7A", null, "Function theory less than"),

  /// Function theory m.
  functionMLower("U+ED01", null, "Function theory m"),

  /// Function theory M.
  functionMUpper("U+ED00", null, "Function theory M"),

  /// Function theory minus.
  functionMinus("U+EA7B", null, "Function theory minus"),

  /// Function theory n.
  functionNLower("U+EA86", null, "Function theory n"),

  /// Function theory N.
  functionNUpper("U+EA85", null, "Function theory N"),

  /// Function theory superscript N.
  functionNUpperSuperscript("U+ED02", null, "Function theory superscript N"),

  /// Function theory 9.
  functionNine("U+EA79", null, "Function theory 9"),

  /// Function theory 1.
  functionOne("U+EA71", null, "Function theory 1"),

  /// Function theory p.
  functionPLower("U+EA88", null, "Function theory p"),

  /// Function theory P.
  functionPUpper("U+EA87", null, "Function theory P"),

  /// Function theory parenthesis left.
  functionParensLeft("U+EA91", null, "Function theory parenthesis left"),

  /// Function theory parenthesis right.
  functionParensRight("U+EA92", null, "Function theory parenthesis right"),

  /// Function theory prefix plus.
  functionPlus("U+EA98", null, "Function theory prefix plus"),

  /// Function theory r.
  functionRLower("U+ED03", null, "Function theory r"),

  /// Function theory repetition 1.
  functionRepetition1("U+EA95", null, "Function theory repetition 1"),

  /// Function theory repetition 2.
  functionRepetition2("U+EA96", null, "Function theory repetition 2"),

  /// Function theory prefix ring.
  functionRing("U+EA97", null, "Function theory prefix ring"),

  /// Function theory minor subdominant.
  functionSLower("U+EA8A", null, "Function theory minor subdominant"),

  /// Function theory minor subdominant of subdominant.
  functionSSLower(
      "U+EA7E", null, "Function theory minor subdominant of subdominant"),

  /// Function theory major subdominant of subdominant.
  functionSSUpper(
      "U+EA7D", null, "Function theory major subdominant of subdominant"),

  /// Function theory major subdominant.
  functionSUpper("U+EA89", null, "Function theory major subdominant"),

  /// Function theory 7.
  functionSeven("U+EA77", null, "Function theory 7"),

  /// Function theory 6.
  functionSix("U+EA76", null, "Function theory 6"),

  /// Function theory double dominant seventh.
  functionSlashedDD("U+EA82", null, "Function theory double dominant seventh"),

  /// Function theory minor tonic.
  functionTLower("U+EA8C", null, "Function theory minor tonic"),

  /// Function theory tonic.
  functionTUpper("U+EA8B", null, "Function theory tonic"),

  /// Function theory 3.
  functionThree("U+EA73", null, "Function theory 3"),

  /// Function theory 2.
  functionTwo("U+EA72", null, "Function theory 2"),

  /// Function theory v.
  functionVLower("U+EA8E", null, "Function theory v"),

  /// Function theory V.
  functionVUpper("U+EA8D", null, "Function theory V"),

  /// Function theory 0.
  functionZero("U+EA70", null, "Function theory 0"),

  /// G clef.
  gClef("U+E050", "U+1D11E", "G clef"),

  /// G clef quindicesima alta.
  gClef15ma("U+E054", null, "G clef quindicesima alta"),

  /// G clef quindicesima bassa.
  gClef15mb("U+E051", null, "G clef quindicesima bassa"),

  /// G clef ottava alta.
  gClef8va("U+E053", "U+1D11F", "G clef ottava alta"),

  /// G clef ottava bassa.
  gClef8vb("U+E052", "U+1D120", "G clef ottava bassa"),

  /// G clef ottava bassa with C clef.
  gClef8vbCClef("U+E056", null, "G clef ottava bassa with C clef"),

  /// G clef ottava bassa (old style).
  gClef8vbOld("U+E055", null, "G clef ottava bassa (old style)"),

  /// G clef, optionally ottava bassa.
  gClef8vbParens("U+E057", null, "G clef, optionally ottava bassa"),

  /// G clef, arrow down.
  gClefArrowDown("U+E05B", null, "G clef, arrow down"),

  /// G clef, arrow up.
  gClefArrowUp("U+E05A", null, "G clef, arrow up"),

  /// G clef change.
  gClefChange("U+E07A", null, "G clef change"),

  /// Combining G clef, number above.
  gClefLigatedNumberAbove("U+E059", null, "Combining G clef, number above"),

  /// Combining G clef, number below.
  gClefLigatedNumberBelow("U+E058", null, "Combining G clef, number below"),

  /// Reversed G clef.
  gClefReversed("U+E073", null, "Reversed G clef"),

  /// Turned G clef.
  gClefTurned("U+E074", null, "Turned G clef"),

  /// Glissando down.
  glissandoDown("U+E586", "U+1D1B2", "Glissando down"),

  /// Glissando up.
  glissandoUp("U+E585", "U+1D1B1", "Glissando up"),

  /// Slashed grace note stem down.
  graceNoteAcciaccaturaStemDown("U+E561", null, "Slashed grace note stem down"),

  /// Slashed grace note stem up.
  graceNoteAcciaccaturaStemUp(
      "U+E560", "U+1D194", "Slashed grace note stem up"),

  /// Grace note stem down.
  graceNoteAppoggiaturaStemDown("U+E563", null, "Grace note stem down"),

  /// Grace note stem up.
  graceNoteAppoggiaturaStemUp("U+E562", "U+1D195", "Grace note stem up"),

  /// Slash for stem down grace note.
  graceNoteSlashStemDown("U+E565", null, "Slash for stem down grace note"),

  /// Slash for stem up grace note.
  graceNoteSlashStemUp("U+E564", null, "Slash for stem up grace note"),

  /// Full barré.
  guitarBarreFull("U+E848", null, "Full barré"),

  /// Half barré.
  guitarBarreHalf("U+E849", null, "Half barré"),

  /// Closed wah/volume pedal.
  guitarClosePedal("U+E83F", null, "Closed wah/volume pedal"),

  /// Fade in.
  guitarFadeIn("U+E843", null, "Fade in"),

  /// Fade out.
  guitarFadeOut("U+E844", null, "Fade out"),

  /// Golpe (tapping the pick guard).
  guitarGolpe("U+E842", null, "Golpe (tapping the pick guard)"),

  /// Half-open wah/volume pedal.
  guitarHalfOpenPedal("U+E83E", null, "Half-open wah/volume pedal"),

  /// Left-hand tapping.
  guitarLeftHandTapping("U+E840", null, "Left-hand tapping"),

  /// Open wah/volume pedal.
  guitarOpenPedal("U+E83D", null, "Open wah/volume pedal"),

  /// Right-hand tapping.
  guitarRightHandTapping("U+E841", null, "Right-hand tapping"),

  /// Guitar shake.
  guitarShake("U+E832", null, "Guitar shake"),

  /// String number 0.
  guitarString0("U+E833", null, "String number 0"),

  /// String number 1.
  guitarString1("U+E834", null, "String number 1"),

  /// String number 10.
  guitarString10("U+E84A", null, "String number 10"),

  /// String number 11.
  guitarString11("U+E84B", null, "String number 11"),

  /// String number 12.
  guitarString12("U+E84C", null, "String number 12"),

  /// String number 13.
  guitarString13("U+E84D", null, "String number 13"),

  /// String number 2.
  guitarString2("U+E835", null, "String number 2"),

  /// String number 3.
  guitarString3("U+E836", null, "String number 3"),

  /// String number 4.
  guitarString4("U+E837", null, "String number 4"),

  /// String number 5.
  guitarString5("U+E838", null, "String number 5"),

  /// String number 6.
  guitarString6("U+E839", null, "String number 6"),

  /// String number 7.
  guitarString7("U+E83A", null, "String number 7"),

  /// String number 8.
  guitarString8("U+E83B", null, "String number 8"),

  /// String number 9.
  guitarString9("U+E83C", null, "String number 9"),

  /// Strum direction down.
  guitarStrumDown("U+E847", null, "Strum direction down"),

  /// Strum direction up.
  guitarStrumUp("U+E846", null, "Strum direction up"),

  /// Guitar vibrato bar dip.
  guitarVibratoBarDip("U+E831", null, "Guitar vibrato bar dip"),

  /// Guitar vibrato bar scoop.
  guitarVibratoBarScoop("U+E830", null, "Guitar vibrato bar scoop"),

  /// Vibrato wiggle segment.
  guitarVibratoStroke("U+EAB2", null, "Vibrato wiggle segment"),

  /// Volume swell.
  guitarVolumeSwell("U+E845", null, "Volume swell"),

  /// Wide vibrato wiggle segment.
  guitarWideVibratoStroke("U+EAB3", null, "Wide vibrato wiggle segment"),

  /// Belltree.
  handbellsBelltree("U+E81F", null, "Belltree"),

  /// Damp 3.
  handbellsDamp3("U+E81E", null, "Damp 3"),

  /// Echo.
  handbellsEcho1("U+E81B", null, "Echo"),

  /// Echo 2.
  handbellsEcho2("U+E81C", null, "Echo 2"),

  /// Gyro.
  handbellsGyro("U+E81D", null, "Gyro"),

  /// Hand martellato.
  handbellsHandMartellato("U+E812", null, "Hand martellato"),

  /// Mallet, bell on table.
  handbellsMalletBellOnTable("U+E815", null, "Mallet, bell on table"),

  /// Mallet, bell suspended.
  handbellsMalletBellSuspended("U+E814", null, "Mallet, bell suspended"),

  /// Mallet lift.
  handbellsMalletLft("U+E816", null, "Mallet lift"),

  /// Martellato.
  handbellsMartellato("U+E810", null, "Martellato"),

  /// Martellato lift.
  handbellsMartellatoLift("U+E811", null, "Martellato lift"),

  /// Muted martellato.
  handbellsMutedMartellato("U+E813", null, "Muted martellato"),

  /// Pluck lift.
  handbellsPluckLift("U+E817", null, "Pluck lift"),

  /// Swing.
  handbellsSwing("U+E81A", null, "Swing"),

  /// Swing down.
  handbellsSwingDown("U+E819", null, "Swing down"),

  /// Swing up.
  handbellsSwingUp("U+E818", null, "Swing up"),

  /// Table pair of handbells.
  handbellsTablePairBells("U+E821", null, "Table pair of handbells"),

  /// Table single handbell.
  handbellsTableSingleBell("U+E820", null, "Table single handbell"),

  /// Metal rod pictogram.
  harpMetalRod("U+E68F", null, "Metal rod pictogram"),

  /// Harp pedal centered (natural).
  harpPedalCentered("U+E681", null, "Harp pedal centered (natural)"),

  /// Harp pedal divider.
  harpPedalDivider("U+E683", null, "Harp pedal divider"),

  /// Harp pedal lowered (sharp).
  harpPedalLowered("U+E682", null, "Harp pedal lowered (sharp)"),

  /// Harp pedal raised (flat).
  harpPedalRaised("U+E680", null, "Harp pedal raised (flat)"),

  /// Ascending aeolian chords (Salzedo).
  harpSalzedoAeolianAscending(
      "U+E695", null, "Ascending aeolian chords (Salzedo)"),

  /// Descending aeolian chords (Salzedo).
  harpSalzedoAeolianDescending(
      "U+E696", null, "Descending aeolian chords (Salzedo)"),

  /// Damp above (Salzedo).
  harpSalzedoDampAbove("U+E69A", null, "Damp above (Salzedo)"),

  /// Damp below (Salzedo).
  harpSalzedoDampBelow("U+E699", null, "Damp below (Salzedo)"),

  /// Damp with both hands (Salzedo).
  harpSalzedoDampBothHands("U+E698", null, "Damp with both hands (Salzedo)"),

  /// Damp only low strings (Salzedo).
  harpSalzedoDampLowStrings("U+E697", null, "Damp only low strings (Salzedo)"),

  /// Fluidic sounds, left hand (Salzedo).
  harpSalzedoFluidicSoundsLeft(
      "U+E68D", null, "Fluidic sounds, left hand (Salzedo)"),

  /// Fluidic sounds, right hand (Salzedo).
  harpSalzedoFluidicSoundsRight(
      "U+E68E", null, "Fluidic sounds, right hand (Salzedo)"),

  /// Isolated sounds (Salzedo).
  harpSalzedoIsolatedSounds("U+E69C", null, "Isolated sounds (Salzedo)"),

  /// Metallic sounds (Salzedo).
  harpSalzedoMetallicSounds("U+E688", null, "Metallic sounds (Salzedo)"),

  /// Metallic sounds, one string (Salzedo).
  harpSalzedoMetallicSoundsOneString(
      "U+E69B", null, "Metallic sounds, one string (Salzedo)"),

  /// Muffle totally (Salzedo).
  harpSalzedoMuffleTotally("U+E68C", null, "Muffle totally (Salzedo)"),

  /// Oboic flux (Salzedo).
  harpSalzedoOboicFlux("U+E685", null, "Oboic flux (Salzedo)"),

  /// Play at upper end of strings (Salzedo).
  harpSalzedoPlayUpperEnd(
      "U+E68A", null, "Play at upper end of strings (Salzedo)"),

  /// Slide with suppleness (Salzedo).
  harpSalzedoSlideWithSuppleness(
      "U+E684", null, "Slide with suppleness (Salzedo)"),

  /// Snare drum effect (Salzedo).
  harpSalzedoSnareDrum("U+E69D", null, "Snare drum effect (Salzedo)"),

  /// Tam-tam sounds (Salzedo).
  harpSalzedoTamTamSounds("U+E689", null, "Tam-tam sounds (Salzedo)"),

  /// Thunder effect (Salzedo).
  harpSalzedoThunderEffect("U+E686", null, "Thunder effect (Salzedo)"),

  /// Timpanic sounds (Salzedo).
  harpSalzedoTimpanicSounds("U+E68B", null, "Timpanic sounds (Salzedo)"),

  /// Whistling sounds (Salzedo).
  harpSalzedoWhistlingSounds("U+E687", null, "Whistling sounds (Salzedo)"),

  /// Combining string noise for stem.
  harpStringNoiseStem("U+E694", null, "Combining string noise for stem"),

  /// Tuning key pictogram.
  harpTuningKey("U+E690", null, "Tuning key pictogram"),

  /// Retune strings for glissando.
  harpTuningKeyGlissando("U+E693", null, "Retune strings for glissando"),

  /// Use handle of tuning key pictogram.
  harpTuningKeyHandle("U+E691", null, "Use handle of tuning key pictogram"),

  /// Use shank of tuning key pictogram.
  harpTuningKeyShank("U+E692", null, "Use shank of tuning key pictogram"),

  /// Indian drum clef.
  indianDrumClef("U+ED70", null, "Indian drum clef"),

  /// Back-chug.
  kahnBackChug("U+EDE2", null, "Back-chug"),

  /// Back-flap.
  kahnBackFlap("U+EDD8", null, "Back-flap"),

  /// Back-riff.
  kahnBackRiff("U+EDE1", null, "Back-riff"),

  /// Back-rip.
  kahnBackRip("U+EDDA", null, "Back-rip"),

  /// Ball-change.
  kahnBallChange("U+EDC6", null, "Ball-change"),

  /// Ball-dig.
  kahnBallDig("U+EDCD", null, "Ball-dig"),

  /// Brush-backward.
  kahnBrushBackward("U+EDA7", null, "Brush-backward"),

  /// Brush-forward.
  kahnBrushForward("U+EDA6", null, "Brush-forward"),

  /// Chug.
  kahnChug("U+EDDD", null, "Chug"),

  /// Clap.
  kahnClap("U+EDB8", null, "Clap"),

  /// Double-snap.
  kahnDoubleSnap("U+EDBA", null, "Double-snap"),

  /// Double-wing.
  kahnDoubleWing("U+EDEB", null, "Double-wing"),

  /// Draw-step.
  kahnDrawStep("U+EDB2", null, "Draw-step"),

  /// Draw-tap.
  kahnDrawTap("U+EDB3", null, "Draw-tap"),

  /// Flam.
  kahnFlam("U+EDCF", null, "Flam"),

  /// Flap.
  kahnFlap("U+EDD5", null, "Flap"),

  /// Flap-step.
  kahnFlapStep("U+EDD7", null, "Flap-step"),

  /// Flat.
  kahnFlat("U+EDA9", null, "Flat"),

  /// Flea-hop.
  kahnFleaHop("U+EDB0", null, "Flea-hop"),

  /// Flea-tap.
  kahnFleaTap("U+EDB1", null, "Flea-tap"),

  /// Grace-tap.
  kahnGraceTap("U+EDA8", null, "Grace-tap"),

  /// Grace-tap-change.
  kahnGraceTapChange("U+EDD1", null, "Grace-tap-change"),

  /// Grace-tap-hop.
  kahnGraceTapHop("U+EDD0", null, "Grace-tap-hop"),

  /// Grace-tap-stamp.
  kahnGraceTapStamp("U+EDD3", null, "Grace-tap-stamp"),

  /// Heel.
  kahnHeel("U+EDAA", null, "Heel"),

  /// Heel-change.
  kahnHeelChange("U+EDC9", null, "Heel-change"),

  /// Heel-click.
  kahnHeelClick("U+EDBB", null, "Heel-click"),

  /// Heel-drop.
  kahnHeelDrop("U+EDB6", null, "Heel-drop"),

  /// Heel-step.
  kahnHeelStep("U+EDC4", null, "Heel-step"),

  /// Heel-tap.
  kahnHeelTap("U+EDCB", null, "Heel-tap"),

  /// Hop.
  kahnHop("U+EDA2", null, "Hop"),

  /// Jump-apart.
  kahnJumpApart("U+EDA5", null, "Jump-apart"),

  /// Jump-together.
  kahnJumpTogether("U+EDA4", null, "Jump-together"),

  /// Knee-inward.
  kahnKneeInward("U+EDAD", null, "Knee-inward"),

  /// Knee-outward.
  kahnKneeOutward("U+EDAC", null, "Knee-outward"),

  /// Leap.
  kahnLeap("U+EDA3", null, "Leap"),

  /// Leap-flat-foot.
  kahnLeapFlatFoot("U+EDD2", null, "Leap-flat-foot"),

  /// Leap-heel-click.
  kahnLeapHeelClick("U+EDD4", null, "Leap-heel-click"),

  /// Left-catch.
  kahnLeftCatch("U+EDBF", null, "Left-catch"),

  /// Left-cross.
  kahnLeftCross("U+EDBD", null, "Left-cross"),

  /// Left-foot.
  kahnLeftFoot("U+EDEE", null, "Left-foot"),

  /// Left-toe-strike.
  kahnLeftToeStrike("U+EDC1", null, "Left-toe-strike"),

  /// Left-turn.
  kahnLeftTurn("U+EDF0", null, "Left-turn"),

  /// Over-the-top.
  kahnOverTheTop("U+EDEC", null, "Over-the-top"),

  /// Over-the-top-tap.
  kahnOverTheTopTap("U+EDED", null, "Over-the-top-tap"),

  /// Pull.
  kahnPull("U+EDE3", null, "Pull"),

  /// Push.
  kahnPush("U+EDDE", null, "Push"),

  /// Riff.
  kahnRiff("U+EDE0", null, "Riff"),

  /// Riffle.
  kahnRiffle("U+EDE7", null, "Riffle"),

  /// Right-catch.
  kahnRightCatch("U+EDC0", null, "Right-catch"),

  /// Right-cross.
  kahnRightCross("U+EDBE", null, "Right-cross"),

  /// Right-foot.
  kahnRightFoot("U+EDEF", null, "Right-foot"),

  /// Right-toe-strike.
  kahnRightToeStrike("U+EDC2", null, "Right-toe-strike"),

  /// Right-turn.
  kahnRightTurn("U+EDF1", null, "Right-turn"),

  /// Rip.
  kahnRip("U+EDD6", null, "Rip"),

  /// Ripple.
  kahnRipple("U+EDE8", null, "Ripple"),

  /// Scrape.
  kahnScrape("U+EDAE", null, "Scrape"),

  /// Scuff.
  kahnScuff("U+EDDC", null, "Scuff"),

  /// Scuffle.
  kahnScuffle("U+EDE6", null, "Scuffle"),

  /// Shuffle.
  kahnShuffle("U+EDE5", null, "Shuffle"),

  /// Slam.
  kahnSlam("U+EDCE", null, "Slam"),

  /// Slap.
  kahnSlap("U+EDD9", null, "Slap"),

  /// Slide-step.
  kahnSlideStep("U+EDB4", null, "Slide-step"),

  /// Slide-tap.
  kahnSlideTap("U+EDB5", null, "Slide-tap"),

  /// Snap.
  kahnSnap("U+EDB9", null, "Snap"),

  /// Stamp.
  kahnStamp("U+EDC3", null, "Stamp"),

  /// Stamp-stamp.
  kahnStampStamp("U+EDC8", null, "Stamp-stamp"),

  /// Step.
  kahnStep("U+EDA0", null, "Step"),

  /// Step-stamp.
  kahnStepStamp("U+EDC7", null, "Step-stamp"),

  /// Stomp.
  kahnStomp("U+EDCA", null, "Stomp"),

  /// Stomp-brush.
  kahnStompBrush("U+EDDB", null, "Stomp-brush"),

  /// Tap.
  kahnTap("U+EDA1", null, "Tap"),

  /// Toe.
  kahnToe("U+EDAB", null, "Toe"),

  /// Toe-click.
  kahnToeClick("U+EDBC", null, "Toe-click"),

  /// Toe-drop.
  kahnToeDrop("U+EDB7", null, "Toe-drop"),

  /// Toe-step.
  kahnToeStep("U+EDC5", null, "Toe-step"),

  /// Toe-tap.
  kahnToeTap("U+EDCC", null, "Toe-tap"),

  /// Trench.
  kahnTrench("U+EDAF", null, "Trench"),

  /// Wing.
  kahnWing("U+EDE9", null, "Wing"),

  /// Wing-change.
  kahnWingChange("U+EDEA", null, "Wing-change"),

  /// Zank.
  kahnZank("U+EDE4", null, "Zank"),

  /// Zink.
  kahnZink("U+EDDF", null, "Zink"),

  /// Clavichord bebung, 2 finger movements (above).
  keyboardBebung2DotsAbove(
      "U+E668", null, "Clavichord bebung, 2 finger movements (above)"),

  /// Clavichord bebung, 2 finger movements (below).
  keyboardBebung2DotsBelow(
      "U+E669", null, "Clavichord bebung, 2 finger movements (below)"),

  /// Clavichord bebung, 3 finger movements (above).
  keyboardBebung3DotsAbove(
      "U+E66A", null, "Clavichord bebung, 3 finger movements (above)"),

  /// Clavichord bebung, 3 finger movements (below).
  keyboardBebung3DotsBelow(
      "U+E66B", null, "Clavichord bebung, 3 finger movements (below)"),

  /// Clavichord bebung, 4 finger movements (above).
  keyboardBebung4DotsAbove(
      "U+E66C", null, "Clavichord bebung, 4 finger movements (above)"),

  /// Clavichord bebung, 4 finger movements (below).
  keyboardBebung4DotsBelow(
      "U+E66D", null, "Clavichord bebung, 4 finger movements (below)"),

  /// Left pedal pictogram.
  keyboardLeftPedalPictogram("U+E65E", null, "Left pedal pictogram"),

  /// Middle pedal pictogram.
  keyboardMiddlePedalPictogram("U+E65F", null, "Middle pedal pictogram"),

  /// Pedal d.
  keyboardPedalD("U+E653", null, "Pedal d"),

  /// Pedal dot.
  keyboardPedalDot("U+E654", null, "Pedal dot"),

  /// Pedal e.
  keyboardPedalE("U+E652", null, "Pedal e"),

  /// Half-pedal mark.
  keyboardPedalHalf("U+E656", "U+1D1B0", "Half-pedal mark"),

  /// Half pedal mark 1.
  keyboardPedalHalf2("U+E65B", null, "Half pedal mark 1"),

  /// Half pedal mark 2.
  keyboardPedalHalf3("U+E65C", null, "Half pedal mark 2"),

  /// Pedal heel 1.
  keyboardPedalHeel1("U+E661", null, "Pedal heel 1"),

  /// Pedal heel 2.
  keyboardPedalHeel2("U+E662", null, "Pedal heel 2"),

  /// Pedal heel 3 (Davis).
  keyboardPedalHeel3("U+E663", null, "Pedal heel 3 (Davis)"),

  /// Pedal heel to toe.
  keyboardPedalHeelToToe("U+E674", null, "Pedal heel to toe"),

  /// Pedal heel or toe.
  keyboardPedalHeelToe("U+E666", null, "Pedal heel or toe"),

  /// Pedal hook end.
  keyboardPedalHookEnd("U+E673", null, "Pedal hook end"),

  /// Pedal hook start.
  keyboardPedalHookStart("U+E672", null, "Pedal hook start"),

  /// Pedal hyphen.
  keyboardPedalHyphen("U+E658", null, "Pedal hyphen"),

  /// Pedal P.
  keyboardPedalP("U+E651", null, "Pedal P"),

  /// Left parenthesis for pedal marking.
  keyboardPedalParensLeft("U+E676", null, "Left parenthesis for pedal marking"),

  /// Right parenthesis for pedal marking.
  keyboardPedalParensRight(
      "U+E677", null, "Right parenthesis for pedal marking"),

  /// Pedal mark.
  keyboardPedalPed("U+E650", "U+1D1AE", "Pedal mark"),

  /// Pedal S.
  keyboardPedalS("U+E65A", null, "Pedal S"),

  /// Sostenuto pedal mark.
  keyboardPedalSost("U+E659", null, "Sostenuto pedal mark"),

  /// Pedal toe 1.
  keyboardPedalToe1("U+E664", null, "Pedal toe 1"),

  /// Pedal toe 2.
  keyboardPedalToe2("U+E665", null, "Pedal toe 2"),

  /// Pedal toe to heel.
  keyboardPedalToeToHeel("U+E675", null, "Pedal toe to heel"),

  /// Pedal up mark.
  keyboardPedalUp("U+E655", "U+1D1AF", "Pedal up mark"),

  /// Pedal up notch.
  keyboardPedalUpNotch("U+E657", null, "Pedal up notch"),

  /// Pedal up special.
  keyboardPedalUpSpecial("U+E65D", null, "Pedal up special"),

  /// Play with left hand.
  keyboardPlayWithLH("U+E670", null, "Play with left hand"),

  /// Play with left hand (end).
  keyboardPlayWithLHEnd("U+E671", null, "Play with left hand (end)"),

  /// Play with right hand.
  keyboardPlayWithRH("U+E66E", null, "Play with right hand"),

  /// Play with right hand (end).
  keyboardPlayWithRHEnd("U+E66F", null, "Play with right hand (end)"),

  /// Pluck strings inside piano (Maderna).
  keyboardPluckInside("U+E667", null, "Pluck strings inside piano (Maderna)"),

  /// Right pedal pictogram.
  keyboardRightPedalPictogram("U+E660", null, "Right pedal pictogram"),

  /// Kievan flat.
  kievanAccidentalFlat("U+EC3E", "U+1D1E8", "Kievan flat"),

  /// Kievan sharp.
  kievanAccidentalSharp("U+EC3D", null, "Kievan sharp"),

  /// Kievan augmentation dot.
  kievanAugmentationDot("U+EC3C", null, "Kievan augmentation dot"),

  /// Kievan C clef (tse-fa-ut).
  kievanCClef("U+EC30", "U+1D1DE", "Kievan C clef (tse-fa-ut)"),

  /// Kievan ending symbol.
  kievanEndingSymbol("U+EC31", "U+1D1DF", "Kievan ending symbol"),

  /// Kievan eighth note, stem down.
  kievanNote8thStemDown("U+EC3A", "U+1D1E6", "Kievan eighth note, stem down"),

  /// Kievan eighth note, stem up.
  kievanNote8thStemUp("U+EC39", "U+1D1E7", "Kievan eighth note, stem up"),

  /// Kievan beam.
  kievanNoteBeam("U+EC3B", null, "Kievan beam"),

  /// Kievan half note (on staff line).
  kievanNoteHalfStaffLine(
      "U+EC35", "U+1D1E3", "Kievan half note (on staff line)"),

  /// Kievan half note (in staff space).
  kievanNoteHalfStaffSpace("U+EC36", null, "Kievan half note (in staff space)"),

  /// Kievan quarter note, stem down.
  kievanNoteQuarterStemDown(
      "U+EC38", "U+1D1E4", "Kievan quarter note, stem down"),

  /// Kievan quarter note, stem up.
  kievanNoteQuarterStemUp("U+EC37", "U+1D1E5", "Kievan quarter note, stem up"),

  /// Kievan reciting note.
  kievanNoteReciting("U+EC32", "U+1D1E1", "Kievan reciting note"),

  /// Kievan whole note.
  kievanNoteWhole("U+EC33", "U+1D1E2", "Kievan whole note"),

  /// Kievan final whole note.
  kievanNoteWholeFinal("U+EC34", "U+1D1E0", "Kievan final whole note"),

  /// Do hand sign.
  kodalyHandDo("U+EC40", null, "Do hand sign"),

  /// Fa hand sign.
  kodalyHandFa("U+EC43", null, "Fa hand sign"),

  /// La hand sign.
  kodalyHandLa("U+EC45", null, "La hand sign"),

  /// Mi hand sign.
  kodalyHandMi("U+EC42", null, "Mi hand sign"),

  /// Re hand sign.
  kodalyHandRe("U+EC41", null, "Re hand sign"),

  /// So hand sign.
  kodalyHandSo("U+EC44", null, "So hand sign"),

  /// Ti hand sign.
  kodalyHandTi("U+EC46", null, "Ti hand sign"),

  /// Left repeat sign within bar.
  leftRepeatSmall("U+E04C", null, "Left repeat sign within bar"),

  /// Leger line.
  legerLine("U+E022", null, "Leger line"),

  /// Leger line (narrow).
  legerLineNarrow("U+E024", null, "Leger line (narrow)"),

  /// Leger line (wide).
  legerLineWide("U+E023", null, "Leger line (wide)"),

  /// Lute tablature end repeat barline.
  luteBarlineEndRepeat("U+EBA4", null, "Lute tablature end repeat barline"),

  /// Lute tablature final barline.
  luteBarlineFinal("U+EBA5", null, "Lute tablature final barline"),

  /// Lute tablature start repeat barline.
  luteBarlineStartRepeat("U+EBA3", null, "Lute tablature start repeat barline"),

  /// 16th note (semiquaver) duration sign.
  luteDuration16th("U+EBAB", null, "16th note (semiquaver) duration sign"),

  /// 32nd note (demisemiquaver) duration sign.
  luteDuration32nd("U+EBAC", null, "32nd note (demisemiquaver) duration sign"),

  /// Eighth note (quaver) duration sign.
  luteDuration8th("U+EBAA", null, "Eighth note (quaver) duration sign"),

  /// Double whole note (breve) duration sign.
  luteDurationDoubleWhole(
      "U+EBA6", null, "Double whole note (breve) duration sign"),

  /// Half note (minim) duration sign.
  luteDurationHalf("U+EBA8", null, "Half note (minim) duration sign"),

  /// Quarter note (crotchet) duration sign.
  luteDurationQuarter("U+EBA9", null, "Quarter note (crotchet) duration sign"),

  /// Whole note (semibreve) duration sign.
  luteDurationWhole("U+EBA7", null, "Whole note (semibreve) duration sign"),

  /// Right-hand fingering, first finger.
  luteFingeringRHFirst("U+EBAE", null, "Right-hand fingering, first finger"),

  /// Right-hand fingering, second finger.
  luteFingeringRHSecond("U+EBAF", null, "Right-hand fingering, second finger"),

  /// Right-hand fingering, third finger.
  luteFingeringRHThird("U+EBB0", null, "Right-hand fingering, third finger"),

  /// Right-hand fingering, thumb.
  luteFingeringRHThumb("U+EBAD", null, "Right-hand fingering, thumb"),

  /// 10th course (diapason).
  luteFrench10thCourse("U+EBD0", null, "10th course (diapason)"),

  /// Seventh course (diapason).
  luteFrench7thCourse("U+EBCD", null, "Seventh course (diapason)"),

  /// Eighth course (diapason).
  luteFrench8thCourse("U+EBCE", null, "Eighth course (diapason)"),

  /// Ninth course (diapason).
  luteFrench9thCourse("U+EBCF", null, "Ninth course (diapason)"),

  /// Appoggiatura from above.
  luteFrenchAppoggiaturaAbove("U+EBD5", null, "Appoggiatura from above"),

  /// Appoggiatura from below.
  luteFrenchAppoggiaturaBelow("U+EBD4", null, "Appoggiatura from below"),

  /// Open string (a).
  luteFrenchFretA("U+EBC0", null, "Open string (a)"),

  /// First fret (b).
  luteFrenchFretB("U+EBC1", null, "First fret (b)"),

  /// Second fret (c).
  luteFrenchFretC("U+EBC2", null, "Second fret (c)"),

  /// Third fret (d).
  luteFrenchFretD("U+EBC3", null, "Third fret (d)"),

  /// Fourth fret (e).
  luteFrenchFretE("U+EBC4", null, "Fourth fret (e)"),

  /// Fifth fret (f).
  luteFrenchFretF("U+EBC5", null, "Fifth fret (f)"),

  /// Sixth fret (g).
  luteFrenchFretG("U+EBC6", null, "Sixth fret (g)"),

  /// Seventh fret (h).
  luteFrenchFretH("U+EBC7", null, "Seventh fret (h)"),

  /// Eighth fret (i).
  luteFrenchFretI("U+EBC8", null, "Eighth fret (i)"),

  /// Ninth fret (k).
  luteFrenchFretK("U+EBC9", null, "Ninth fret (k)"),

  /// 10th fret (l).
  luteFrenchFretL("U+EBCA", null, "10th fret (l)"),

  /// 11th fret (m).
  luteFrenchFretM("U+EBCB", null, "11th fret (m)"),

  /// 12th fret (n).
  luteFrenchFretN("U+EBCC", null, "12th fret (n)"),

  /// Inverted mordent.
  luteFrenchMordentInverted("U+EBD3", null, "Inverted mordent"),

  /// Mordent with lower auxiliary.
  luteFrenchMordentLower("U+EBD2", null, "Mordent with lower auxiliary"),

  /// Mordent with upper auxiliary.
  luteFrenchMordentUpper("U+EBD1", null, "Mordent with upper auxiliary"),

  /// 5th course, 1st fret (a).
  luteGermanALower("U+EC00", null, "5th course, 1st fret (a)"),

  /// 6th course, 1st fret (A).
  luteGermanAUpper("U+EC17", null, "6th course, 1st fret (A)"),

  /// 4th course, 1st fret (b).
  luteGermanBLower("U+EC01", null, "4th course, 1st fret (b)"),

  /// 6th course, 2nd fret (B).
  luteGermanBUpper("U+EC18", null, "6th course, 2nd fret (B)"),

  /// 3rd course, 1st fret (c).
  luteGermanCLower("U+EC02", null, "3rd course, 1st fret (c)"),

  /// 6th course, 3rd fret (C).
  luteGermanCUpper("U+EC19", null, "6th course, 3rd fret (C)"),

  /// 2nd course, 1st fret (d).
  luteGermanDLower("U+EC03", null, "2nd course, 1st fret (d)"),

  /// 6th course, 4th fret (D).
  luteGermanDUpper("U+EC1A", null, "6th course, 4th fret (D)"),

  /// 1st course, 1st fret (e).
  luteGermanELower("U+EC04", null, "1st course, 1st fret (e)"),

  /// 6th course, 5th fret (E).
  luteGermanEUpper("U+EC1B", null, "6th course, 5th fret (E)"),

  /// 5th course, 2nd fret (f).
  luteGermanFLower("U+EC05", null, "5th course, 2nd fret (f)"),

  /// 6th course, 6th fret (F).
  luteGermanFUpper("U+EC1C", null, "6th course, 6th fret (F)"),

  /// 4th course, 2nd fret (g).
  luteGermanGLower("U+EC06", null, "4th course, 2nd fret (g)"),

  /// 6th course, 7th fret (G).
  luteGermanGUpper("U+EC1D", null, "6th course, 7th fret (G)"),

  /// 3rd course, 2nd fret (h).
  luteGermanHLower("U+EC07", null, "3rd course, 2nd fret (h)"),

  /// 6th course, 8th fret (H).
  luteGermanHUpper("U+EC1E", null, "6th course, 8th fret (H)"),

  /// 2nd course, 2nd fret (i).
  luteGermanILower("U+EC08", null, "2nd course, 2nd fret (i)"),

  /// 6th course, 9th fret (I).
  luteGermanIUpper("U+EC1F", null, "6th course, 9th fret (I)"),

  /// 1st course, 2nd fret (k).
  luteGermanKLower("U+EC09", null, "1st course, 2nd fret (k)"),

  /// 6th course, 10th fret (K).
  luteGermanKUpper("U+EC20", null, "6th course, 10th fret (K)"),

  /// 5th course, 3rd fret (l).
  luteGermanLLower("U+EC0A", null, "5th course, 3rd fret (l)"),

  /// 6th course, 11th fret (L).
  luteGermanLUpper("U+EC21", null, "6th course, 11th fret (L)"),

  /// 4th course, 3rd fret (m).
  luteGermanMLower("U+EC0B", null, "4th course, 3rd fret (m)"),

  /// 6th course, 12th fret (M).
  luteGermanMUpper("U+EC22", null, "6th course, 12th fret (M)"),

  /// 3rd course, 3rd fret (n).
  luteGermanNLower("U+EC0C", null, "3rd course, 3rd fret (n)"),

  /// 6th course, 13th fret (N).
  luteGermanNUpper("U+EC23", null, "6th course, 13th fret (N)"),

  /// 2nd course, 3rd fret (o).
  luteGermanOLower("U+EC0D", null, "2nd course, 3rd fret (o)"),

  /// 1st course, 3rd fret (p).
  luteGermanPLower("U+EC0E", null, "1st course, 3rd fret (p)"),

  /// 5th course, 4th fret (q).
  luteGermanQLower("U+EC0F", null, "5th course, 4th fret (q)"),

  /// 4th course, 4th fret (r).
  luteGermanRLower("U+EC10", null, "4th course, 4th fret (r)"),

  /// 3rd course, 4th fret (s).
  luteGermanSLower("U+EC11", null, "3rd course, 4th fret (s)"),

  /// 2nd course, 4th fret (t).
  luteGermanTLower("U+EC12", null, "2nd course, 4th fret (t)"),

  /// 1st course, 4th fret (v).
  luteGermanVLower("U+EC13", null, "1st course, 4th fret (v)"),

  /// 5th course, 5th fret (x).
  luteGermanXLower("U+EC14", null, "5th course, 5th fret (x)"),

  /// 4th course, 5th fret (y).
  luteGermanYLower("U+EC15", null, "4th course, 5th fret (y)"),

  /// 3rd course, 5th fret (z).
  luteGermanZLower("U+EC16", null, "3rd course, 5th fret (z)"),

  /// C sol fa ut clef.
  luteItalianClefCSolFaUt("U+EBF1", null, "C sol fa ut clef"),

  /// F fa ut clef.
  luteItalianClefFFaUt("U+EBF0", null, "F fa ut clef"),

  /// Open string (0).
  luteItalianFret0("U+EBE0", null, "Open string (0)"),

  /// First fret (1).
  luteItalianFret1("U+EBE1", null, "First fret (1)"),

  /// Second fret (2).
  luteItalianFret2("U+EBE2", null, "Second fret (2)"),

  /// Third fret (3).
  luteItalianFret3("U+EBE3", null, "Third fret (3)"),

  /// Fourth fret (4).
  luteItalianFret4("U+EBE4", null, "Fourth fret (4)"),

  /// Fifth fret (5).
  luteItalianFret5("U+EBE5", null, "Fifth fret (5)"),

  /// Sixth fret (6).
  luteItalianFret6("U+EBE6", null, "Sixth fret (6)"),

  /// Seventh fret (7).
  luteItalianFret7("U+EBE7", null, "Seventh fret (7)"),

  /// Eighth fret (8).
  luteItalianFret8("U+EBE8", null, "Eighth fret (8)"),

  /// Ninth fret (9).
  luteItalianFret9("U+EBE9", null, "Ninth fret (9)"),

  /// Hold finger in place.
  luteItalianHoldFinger("U+EBF4", null, "Hold finger in place"),

  /// Hold note.
  luteItalianHoldNote("U+EBF3", null, "Hold note"),

  /// Release finger.
  luteItalianReleaseFinger("U+EBF5", null, "Release finger"),

  /// Fast tempo indication (de Mudarra).
  luteItalianTempoFast("U+EBEA", null, "Fast tempo indication (de Mudarra)"),

  /// Neither fast nor slow tempo indication (de Mudarra).
  luteItalianTempoNeitherFastNorSlow(
      "U+EBEC", null, "Neither fast nor slow tempo indication (de Mudarra)"),

  /// Slow tempo indication (de Mudarra).
  luteItalianTempoSlow("U+EBED", null, "Slow tempo indication (de Mudarra)"),

  /// Somewhat fast tempo indication (de Narvaez).
  luteItalianTempoSomewhatFast(
      "U+EBEB", null, "Somewhat fast tempo indication (de Narvaez)"),

  /// Very slow indication (de Narvaez).
  luteItalianTempoVerySlow("U+EBEE", null, "Very slow indication (de Narvaez)"),

  /// Triple time indication.
  luteItalianTimeTriple("U+EBEF", null, "Triple time indication"),

  /// Single-finger tremolo or mordent.
  luteItalianTremolo("U+EBF2", null, "Single-finger tremolo or mordent"),

  /// Vibrato (verre cassé).
  luteItalianVibrato("U+EBF6", null, "Vibrato (verre cassé)"),

  /// Lute tablature staff, 6 courses.
  luteStaff6Lines("U+EBA0", null, "Lute tablature staff, 6 courses"),

  /// Lute tablature staff, 6 courses (narrow).
  luteStaff6LinesNarrow(
      "U+EBA2", null, "Lute tablature staff, 6 courses (narrow)"),

  /// Lute tablature staff, 6 courses (wide).
  luteStaff6LinesWide("U+EBA1", null, "Lute tablature staff, 6 courses (wide)"),

  /// Elision.
  lyricsElision("U+E551", null, "Elision"),

  /// Narrow elision.
  lyricsElisionNarrow("U+E550", null, "Narrow elision"),

  /// Wide elision.
  lyricsElisionWide("U+E552", null, "Wide elision"),

  /// Baseline hyphen.
  lyricsHyphenBaseline("U+E553", null, "Baseline hyphen"),

  /// Non-breaking baseline hyphen.
  lyricsHyphenBaselineNonBreaking(
      "U+E554", null, "Non-breaking baseline hyphen"),

  /// Text repeats.
  lyricsTextRepeat("U+E555", null, "Text repeats"),

  /// Flat, hard b (mi).
  medRenFlatHardB("U+E9E1", null, "Flat, hard b (mi)"),

  /// Flat, soft b (fa).
  medRenFlatSoftB("U+E9E0", "U+1D1D2", "Flat, soft b (fa)"),

  /// Flat with dot.
  medRenFlatWithDot("U+E9E4", null, "Flat with dot"),

  /// G clef (Corpus Monodicum).
  medRenGClefCMN("U+EA24", null, "G clef (Corpus Monodicum)"),

  /// Liquescence.
  medRenLiquescenceCMN("U+EA22", null, "Liquescence"),

  /// Liquescent ascending (Corpus Monodicum).
  medRenLiquescentAscCMN(
      "U+EA26", null, "Liquescent ascending (Corpus Monodicum)"),

  /// Liquescent descending (Corpus Monodicum).
  medRenLiquescentDescCMN(
      "U+EA27", null, "Liquescent descending (Corpus Monodicum)"),

  /// Natural.
  medRenNatural("U+E9E2", null, "Natural"),

  /// Natural with interrupted cross.
  medRenNaturalWithCross("U+E9E5", null, "Natural with interrupted cross"),

  /// Oriscus (Corpus Monodicum).
  medRenOriscusCMN("U+EA2A", null, "Oriscus (Corpus Monodicum)"),

  /// Plica.
  medRenPlicaCMN("U+EA23", null, "Plica"),

  /// Punctum (Corpus Monodicum).
  medRenPunctumCMN("U+EA25", null, "Punctum (Corpus Monodicum)"),

  /// Quilisma (Corpus Monodicum).
  medRenQuilismaCMN("U+EA28", null, "Quilisma (Corpus Monodicum)"),

  /// Croix.
  medRenSharpCroix("U+E9E3", "U+1D1CF", "Croix"),

  /// Strophicus (Corpus Monodicum).
  medRenStrophicusCMN("U+EA29", null, "Strophicus (Corpus Monodicum)"),

  /// Alteration sign.
  mensuralAlterationSign("U+EA10", null, "Alteration sign"),

  /// Black mensural brevis.
  mensuralBlackBrevis("U+E952", null, "Black mensural brevis"),

  /// Black mensural void brevis.
  mensuralBlackBrevisVoid("U+E956", null, "Black mensural void brevis"),

  /// Black mensural dragma.
  mensuralBlackDragma("U+E95A", null, "Black mensural dragma"),

  /// Black mensural longa.
  mensuralBlackLonga("U+E951", null, "Black mensural longa"),

  /// Black mensural maxima.
  mensuralBlackMaxima("U+E950", null, "Black mensural maxima"),

  /// Black mensural minima.
  mensuralBlackMinima("U+E954", "U+1D1BC", "Black mensural minima"),

  /// Black mensural void minima.
  mensuralBlackMinimaVoid("U+E958", "U+1D1BB", "Black mensural void minima"),

  /// Black mensural semibrevis.
  mensuralBlackSemibrevis("U+E953", "U+1D1BA", "Black mensural semibrevis"),

  /// Black mensural semibrevis caudata.
  mensuralBlackSemibrevisCaudata(
      "U+E959", null, "Black mensural semibrevis caudata"),

  /// Black mensural oblique semibrevis.
  mensuralBlackSemibrevisOblique(
      "U+E95B", null, "Black mensural oblique semibrevis"),

  /// Black mensural void semibrevis.
  mensuralBlackSemibrevisVoid(
      "U+E957", "U+1D1B9", "Black mensural void semibrevis"),

  /// Black mensural semiminima.
  mensuralBlackSemiminima("U+E955", null, "Black mensural semiminima"),

  /// Mensural C clef.
  mensuralCclef("U+E905", null, "Mensural C clef"),

  /// Petrucci C clef, high position.
  mensuralCclefPetrucciPosHigh(
      "U+E90A", null, "Petrucci C clef, high position"),

  /// Petrucci C clef, highest position.
  mensuralCclefPetrucciPosHighest(
      "U+E90B", null, "Petrucci C clef, highest position"),

  /// Petrucci C clef, low position.
  mensuralCclefPetrucciPosLow("U+E908", null, "Petrucci C clef, low position"),

  /// Petrucci C clef, lowest position.
  mensuralCclefPetrucciPosLowest(
      "U+E907", null, "Petrucci C clef, lowest position"),

  /// Petrucci C clef, middle position.
  mensuralCclefPetrucciPosMiddle(
      "U+E909", null, "Petrucci C clef, middle position"),

  /// Coloration end, round.
  mensuralColorationEndRound("U+EA0F", null, "Coloration end, round"),

  /// Coloration end, square.
  mensuralColorationEndSquare("U+EA0D", null, "Coloration end, square"),

  /// Coloration start, round.
  mensuralColorationStartRound("U+EA0E", null, "Coloration start, round"),

  /// Coloration start, square.
  mensuralColorationStartSquare("U+EA0C", null, "Coloration start, square"),

  /// Combining stem diagonal.
  mensuralCombStemDiagonal("U+E940", null, "Combining stem diagonal"),

  /// Combining stem down.
  mensuralCombStemDown("U+E93F", null, "Combining stem down"),

  /// Combining stem with extended flag down.
  mensuralCombStemDownFlagExtended(
      "U+E948", null, "Combining stem with extended flag down"),

  /// Combining stem with flared flag down.
  mensuralCombStemDownFlagFlared(
      "U+E946", null, "Combining stem with flared flag down"),

  /// Combining stem with fusa flag down.
  mensuralCombStemDownFlagFusa(
      "U+E94C", null, "Combining stem with fusa flag down"),

  /// Combining stem with flag left down.
  mensuralCombStemDownFlagLeft(
      "U+E944", null, "Combining stem with flag left down"),

  /// Combining stem with flag right down.
  mensuralCombStemDownFlagRight(
      "U+E942", null, "Combining stem with flag right down"),

  /// Combining stem with semiminima flag down.
  mensuralCombStemDownFlagSemiminima(
      "U+E94A", null, "Combining stem with semiminima flag down"),

  /// Combining stem up.
  mensuralCombStemUp("U+E93E", null, "Combining stem up"),

  /// Combining stem with extended flag up.
  mensuralCombStemUpFlagExtended(
      "U+E947", null, "Combining stem with extended flag up"),

  /// Combining stem with flared flag up.
  mensuralCombStemUpFlagFlared(
      "U+E945", null, "Combining stem with flared flag up"),

  /// Combining stem with fusa flag up.
  mensuralCombStemUpFlagFusa(
      "U+E94B", null, "Combining stem with fusa flag up"),

  /// Combining stem with flag left up.
  mensuralCombStemUpFlagLeft(
      "U+E943", null, "Combining stem with flag left up"),

  /// Combining stem with flag right up.
  mensuralCombStemUpFlagRight(
      "U+E941", null, "Combining stem with flag right up"),

  /// Combining stem with semiminima flag up.
  mensuralCombStemUpFlagSemiminima(
      "U+E949", null, "Combining stem with semiminima flag up"),

  /// Checkmark custos.
  mensuralCustosCheckmark("U+EA0A", null, "Checkmark custos"),

  /// Mensural custos down.
  mensuralCustosDown("U+EA03", null, "Mensural custos down"),

  /// Turn-like custos.
  mensuralCustosTurn("U+EA0B", null, "Turn-like custos"),

  /// Mensural custos up.
  mensuralCustosUp("U+EA02", null, "Mensural custos up"),

  /// Mensural F clef.
  mensuralFclef("U+E903", null, "Mensural F clef"),

  /// Petrucci F clef.
  mensuralFclefPetrucci("U+E904", null, "Petrucci F clef"),

  /// Mensural G clef.
  mensuralGclef("U+E900", null, "Mensural G clef"),

  /// Petrucci G clef.
  mensuralGclefPetrucci("U+E901", null, "Petrucci G clef"),

  /// Modus imperfectum, vertical.
  mensuralModusImperfectumVert("U+E92D", null, "Modus imperfectum, vertical"),

  /// Modus perfectum, vertical.
  mensuralModusPerfectumVert("U+E92C", null, "Modus perfectum, vertical"),

  /// Longa/brevis notehead, black.
  mensuralNoteheadLongaBlack("U+E934", null, "Longa/brevis notehead, black"),

  /// Longa/brevis notehead, black and void.
  mensuralNoteheadLongaBlackVoid(
      "U+E936", null, "Longa/brevis notehead, black and void"),

  /// Longa/brevis notehead, void.
  mensuralNoteheadLongaVoid("U+E935", null, "Longa/brevis notehead, void"),

  /// Longa/brevis notehead, white.
  mensuralNoteheadLongaWhite("U+E937", null, "Longa/brevis notehead, white"),

  /// Maxima notehead, black.
  mensuralNoteheadMaximaBlack("U+E930", null, "Maxima notehead, black"),

  /// Maxima notehead, black and void.
  mensuralNoteheadMaximaBlackVoid(
      "U+E932", null, "Maxima notehead, black and void"),

  /// Maxima notehead, void.
  mensuralNoteheadMaximaVoid("U+E931", null, "Maxima notehead, void"),

  /// Maxima notehead, white.
  mensuralNoteheadMaximaWhite("U+E933", null, "Maxima notehead, white"),

  /// Minima notehead, white.
  mensuralNoteheadMinimaWhite("U+E93C", null, "Minima notehead, white"),

  /// Semibrevis notehead, black.
  mensuralNoteheadSemibrevisBlack("U+E938", null, "Semibrevis notehead, black"),

  /// Semibrevis notehead, black and void.
  mensuralNoteheadSemibrevisBlackVoid(
      "U+E93A", null, "Semibrevis notehead, black and void"),

  /// Semibrevis notehead, black and void (turned).
  mensuralNoteheadSemibrevisBlackVoidTurned(
      "U+E93B", null, "Semibrevis notehead, black and void (turned)"),

  /// Semibrevis notehead, void.
  mensuralNoteheadSemibrevisVoid("U+E939", null, "Semibrevis notehead, void"),

  /// Semiminima/fusa notehead, white.
  mensuralNoteheadSemiminimaWhite(
      "U+E93D", null, "Semiminima/fusa notehead, white"),

  /// Oblique form, ascending 2nd, black.
  mensuralObliqueAsc2ndBlack(
      "U+E970", null, "Oblique form, ascending 2nd, black"),

  /// Oblique form, ascending 2nd, black and void.
  mensuralObliqueAsc2ndBlackVoid(
      "U+E972", null, "Oblique form, ascending 2nd, black and void"),

  /// Oblique form, ascending 2nd, void.
  mensuralObliqueAsc2ndVoid(
      "U+E971", null, "Oblique form, ascending 2nd, void"),

  /// Oblique form, ascending 2nd, white.
  mensuralObliqueAsc2ndWhite(
      "U+E973", null, "Oblique form, ascending 2nd, white"),

  /// Oblique form, ascending 3rd, black.
  mensuralObliqueAsc3rdBlack(
      "U+E974", null, "Oblique form, ascending 3rd, black"),

  /// Oblique form, ascending 3rd, black and void.
  mensuralObliqueAsc3rdBlackVoid(
      "U+E976", null, "Oblique form, ascending 3rd, black and void"),

  /// Oblique form, ascending 3rd, void.
  mensuralObliqueAsc3rdVoid(
      "U+E975", null, "Oblique form, ascending 3rd, void"),

  /// Oblique form, ascending 3rd, white.
  mensuralObliqueAsc3rdWhite(
      "U+E977", null, "Oblique form, ascending 3rd, white"),

  /// Oblique form, ascending 4th, black.
  mensuralObliqueAsc4thBlack(
      "U+E978", null, "Oblique form, ascending 4th, black"),

  /// Oblique form, ascending 4th, black and void.
  mensuralObliqueAsc4thBlackVoid(
      "U+E97A", null, "Oblique form, ascending 4th, black and void"),

  /// Oblique form, ascending 4th, void.
  mensuralObliqueAsc4thVoid(
      "U+E979", null, "Oblique form, ascending 4th, void"),

  /// Oblique form, ascending 4th, white.
  mensuralObliqueAsc4thWhite(
      "U+E97B", null, "Oblique form, ascending 4th, white"),

  /// Oblique form, ascending 5th, black.
  mensuralObliqueAsc5thBlack(
      "U+E97C", null, "Oblique form, ascending 5th, black"),

  /// Oblique form, ascending 5th, black and void.
  mensuralObliqueAsc5thBlackVoid(
      "U+E97E", null, "Oblique form, ascending 5th, black and void"),

  /// Oblique form, ascending 5th, void.
  mensuralObliqueAsc5thVoid(
      "U+E97D", null, "Oblique form, ascending 5th, void"),

  /// Oblique form, ascending 5th, white.
  mensuralObliqueAsc5thWhite(
      "U+E97F", null, "Oblique form, ascending 5th, white"),

  /// Oblique form, descending 2nd, black.
  mensuralObliqueDesc2ndBlack(
      "U+E980", null, "Oblique form, descending 2nd, black"),

  /// Oblique form, descending 2nd, black and void.
  mensuralObliqueDesc2ndBlackVoid(
      "U+E982", null, "Oblique form, descending 2nd, black and void"),

  /// Oblique form, descending 2nd, void.
  mensuralObliqueDesc2ndVoid(
      "U+E981", null, "Oblique form, descending 2nd, void"),

  /// Oblique form, descending 2nd, white.
  mensuralObliqueDesc2ndWhite(
      "U+E983", null, "Oblique form, descending 2nd, white"),

  /// Oblique form, descending 3rd, black.
  mensuralObliqueDesc3rdBlack(
      "U+E984", null, "Oblique form, descending 3rd, black"),

  /// Oblique form, descending 3rd, black and void.
  mensuralObliqueDesc3rdBlackVoid(
      "U+E986", null, "Oblique form, descending 3rd, black and void"),

  /// Oblique form, descending 3rd, void.
  mensuralObliqueDesc3rdVoid(
      "U+E985", null, "Oblique form, descending 3rd, void"),

  /// Oblique form, descending 3rd, white.
  mensuralObliqueDesc3rdWhite(
      "U+E987", null, "Oblique form, descending 3rd, white"),

  /// Oblique form, descending 4th, black.
  mensuralObliqueDesc4thBlack(
      "U+E988", null, "Oblique form, descending 4th, black"),

  /// Oblique form, descending 4th, black and void.
  mensuralObliqueDesc4thBlackVoid(
      "U+E98A", null, "Oblique form, descending 4th, black and void"),

  /// Oblique form, descending 4th, void.
  mensuralObliqueDesc4thVoid(
      "U+E989", null, "Oblique form, descending 4th, void"),

  /// Oblique form, descending 4th, white.
  mensuralObliqueDesc4thWhite(
      "U+E98B", null, "Oblique form, descending 4th, white"),

  /// Oblique form, descending 5th, black.
  mensuralObliqueDesc5thBlack(
      "U+E98C", null, "Oblique form, descending 5th, black"),

  /// Oblique form, descending 5th, black and void.
  mensuralObliqueDesc5thBlackVoid(
      "U+E98E", null, "Oblique form, descending 5th, black and void"),

  /// Oblique form, descending 5th, void.
  mensuralObliqueDesc5thVoid(
      "U+E98D", null, "Oblique form, descending 5th, void"),

  /// Oblique form, descending 5th, white.
  mensuralObliqueDesc5thWhite(
      "U+E98F", null, "Oblique form, descending 5th, white"),

  /// Tempus perfectum cum prolatione perfecta (9/8).
  mensuralProlation1(
      "U+E910", "U+1D1C7", "Tempus perfectum cum prolatione perfecta (9/8)"),

  /// Tempus imperfectum cum prolatione imperfecta diminution 4.
  mensuralProlation10("U+E919", "U+1D1CE",
      "Tempus imperfectum cum prolatione imperfecta diminution 4"),

  /// Tempus imperfectum cum prolatione imperfecta diminution 5.
  mensuralProlation11("U+E91A", null,
      "Tempus imperfectum cum prolatione imperfecta diminution 5"),

  /// Tempus perfectum cum prolatione imperfecta (3/4).
  mensuralProlation2(
      "U+E911", "U+1D1C8", "Tempus perfectum cum prolatione imperfecta (3/4)"),

  /// Tempus perfectum cum prolatione imperfecta diminution 1 (3/8).
  mensuralProlation3("U+E912", "U+1D1C9",
      "Tempus perfectum cum prolatione imperfecta diminution 1 (3/8)"),

  /// Tempus perfectum cum prolatione perfecta diminution 2 (9/16).
  mensuralProlation4("U+E913", null,
      "Tempus perfectum cum prolatione perfecta diminution 2 (9/16)"),

  /// Tempus imperfectum cum prolatione perfecta (6/8).
  mensuralProlation5(
      "U+E914", "U+1D1CA", "Tempus imperfectum cum prolatione perfecta (6/8)"),

  /// Tempus imperfectum cum prolatione imperfecta (2/4).
  mensuralProlation6("U+E915", "U+1D1CB",
      "Tempus imperfectum cum prolatione imperfecta (2/4)"),

  /// Tempus imperfectum cum prolatione imperfecta diminution 1 (2/2).
  mensuralProlation7("U+E916", "U+1D1CC",
      "Tempus imperfectum cum prolatione imperfecta diminution 1 (2/2)"),

  /// Tempus imperfectum cum prolatione imperfecta diminution 2 (6/16).
  mensuralProlation8("U+E917", null,
      "Tempus imperfectum cum prolatione imperfecta diminution 2 (6/16)"),

  /// Tempus imperfectum cum prolatione imperfecta diminution 3 (2/2).
  mensuralProlation9("U+E918", "U+1D1CD",
      "Tempus imperfectum cum prolatione imperfecta diminution 3 (2/2)"),

  /// Combining dot.
  mensuralProlationCombiningDot("U+E920", null, "Combining dot"),

  /// Combining void dot.
  mensuralProlationCombiningDotVoid("U+E924", null, "Combining void dot"),

  /// Combining vertical stroke.
  mensuralProlationCombiningStroke("U+E925", null, "Combining vertical stroke"),

  /// Combining three dots horizontal.
  mensuralProlationCombiningThreeDots(
      "U+E922", null, "Combining three dots horizontal"),

  /// Combining three dots triangular.
  mensuralProlationCombiningThreeDotsTri(
      "U+E923", null, "Combining three dots triangular"),

  /// Combining two dots.
  mensuralProlationCombiningTwoDots("U+E921", null, "Combining two dots"),

  /// Mensural proportion 1.
  mensuralProportion1("U+E926", null, "Mensural proportion 1"),

  /// Mensural proportion 2.
  mensuralProportion2("U+E927", null, "Mensural proportion 2"),

  /// Mensural proportion 3.
  mensuralProportion3("U+E928", null, "Mensural proportion 3"),

  /// Mensural proportion 4.
  mensuralProportion4("U+E929", null, "Mensural proportion 4"),

  /// Mensural proportion 5.
  mensuralProportion5("U+EE90", null, "Mensural proportion 5"),

  /// Mensural proportion 6.
  mensuralProportion6("U+EE91", null, "Mensural proportion 6"),

  /// Mensural proportion 7.
  mensuralProportion7("U+EE92", null, "Mensural proportion 7"),

  /// Mensural proportion 8.
  mensuralProportion8("U+EE93", null, "Mensural proportion 8"),

  /// Mensural proportion 9.
  mensuralProportion9("U+EE94", null, "Mensural proportion 9"),

  /// Mensural proportion major.
  mensuralProportionMajor("U+E92B", null, "Mensural proportion major"),

  /// Mensural proportion minor.
  mensuralProportionMinor("U+E92A", null, "Mensural proportion minor"),

  /// Proportio dupla 1.
  mensuralProportionProportioDupla1("U+E91C", null, "Proportio dupla 1"),

  /// Proportio dupla 2.
  mensuralProportionProportioDupla2("U+E91D", null, "Proportio dupla 2"),

  /// Proportio quadrupla.
  mensuralProportionProportioQuadrupla("U+E91F", null, "Proportio quadrupla"),

  /// Proportio tripla.
  mensuralProportionProportioTripla("U+E91E", null, "Proportio tripla"),

  /// Tempus perfectum.
  mensuralProportionTempusPerfectum("U+E91B", null, "Tempus perfectum"),

  /// Brevis rest.
  mensuralRestBrevis("U+E9F3", "U+1D1C3", "Brevis rest"),

  /// Fusa rest.
  mensuralRestFusa("U+E9F7", null, "Fusa rest"),

  /// Longa imperfecta rest.
  mensuralRestLongaImperfecta("U+E9F2", "U+1D1C2", "Longa imperfecta rest"),

  /// Longa perfecta rest.
  mensuralRestLongaPerfecta("U+E9F1", "U+1D1C1", "Longa perfecta rest"),

  /// Maxima rest.
  mensuralRestMaxima("U+E9F0", null, "Maxima rest"),

  /// Minima rest.
  mensuralRestMinima("U+E9F5", "U+1D1C5", "Minima rest"),

  /// Semibrevis rest.
  mensuralRestSemibrevis("U+E9F4", "U+1D1C4", "Semibrevis rest"),

  /// Semifusa rest.
  mensuralRestSemifusa("U+E9F8", null, "Semifusa rest"),

  /// Semiminima rest.
  mensuralRestSemiminima("U+E9F6", "U+1D1C6", "Semiminima rest"),

  /// Signum congruentiae down.
  mensuralSignumDown("U+EA01", null, "Signum congruentiae down"),

  /// Signum congruentiae up.
  mensuralSignumUp("U+EA00", null, "Signum congruentiae up"),

  /// Tempus imperfectum, horizontal.
  mensuralTempusImperfectumHoriz(
      "U+E92F", null, "Tempus imperfectum, horizontal"),

  /// Tempus perfectum, horizontal.
  mensuralTempusPerfectumHoriz("U+E92E", null, "Tempus perfectum, horizontal"),

  /// White mensural brevis.
  mensuralWhiteBrevis("U+E95E", "U+1D1B8", "White mensural brevis"),

  /// White mensural fusa.
  mensuralWhiteFusa("U+E961", "U+1D1BE", "White mensural fusa"),

  /// White mensural longa.
  mensuralWhiteLonga("U+E95D", "U+1D1B7", "White mensural longa"),

  /// White mensural maxima.
  mensuralWhiteMaxima("U+E95C", "U+1D1B6", "White mensural maxima"),

  /// White mensural minima.
  mensuralWhiteMinima("U+E95F", null, "White mensural minima"),

  /// White mensural semibrevis.
  mensuralWhiteSemibrevis("U+E962", "U+1D1B9", "White mensural semibrevis"),

  /// White mensural semiminima.
  mensuralWhiteSemiminima("U+E960", null, "White mensural semiminima"),

  /// Augmentation dot.
  metAugmentationDot("U+ECB7", null, "Augmentation dot"),

  /// 1024th note (semihemidemisemihemidemisemiquaver) stem down.
  metNote1024thDown("U+ECB6", null,
      "1024th note (semihemidemisemihemidemisemiquaver) stem down"),

  /// 1024th note (semihemidemisemihemidemisemiquaver) stem up.
  metNote1024thUp("U+ECB5", null,
      "1024th note (semihemidemisemihemidemisemiquaver) stem up"),

  /// 128th note (semihemidemisemiquaver) stem down.
  metNote128thDown(
      "U+ECB0", null, "128th note (semihemidemisemiquaver) stem down"),

  /// 128th note (semihemidemisemiquaver) stem up.
  metNote128thUp("U+ECAF", null, "128th note (semihemidemisemiquaver) stem up"),

  /// 16th note (semiquaver) stem down.
  metNote16thDown("U+ECAA", null, "16th note (semiquaver) stem down"),

  /// 16th note (semiquaver) stem up.
  metNote16thUp("U+ECA9", null, "16th note (semiquaver) stem up"),

  /// 256th note (demisemihemidemisemiquaver) stem down.
  metNote256thDown(
      "U+ECB2", null, "256th note (demisemihemidemisemiquaver) stem down"),

  /// 256th note (demisemihemidemisemiquaver) stem up.
  metNote256thUp(
      "U+ECB1", null, "256th note (demisemihemidemisemiquaver) stem up"),

  /// 32nd note (demisemiquaver) stem down.
  metNote32ndDown("U+ECAC", null, "32nd note (demisemiquaver) stem down"),

  /// 32nd note (demisemiquaver) stem up.
  metNote32ndUp("U+ECAB", null, "32nd note (demisemiquaver) stem up"),

  /// 512th note (hemidemisemihemidemisemiquaver) stem down.
  metNote512thDown(
      "U+ECB4", null, "512th note (hemidemisemihemidemisemiquaver) stem down"),

  /// 512th note (hemidemisemihemidemisemiquaver) stem up.
  metNote512thUp(
      "U+ECB3", null, "512th note (hemidemisemihemidemisemiquaver) stem up"),

  /// 64th note (hemidemisemiquaver) stem down.
  metNote64thDown("U+ECAE", null, "64th note (hemidemisemiquaver) stem down"),

  /// 64th note (hemidemisemiquaver) stem up.
  metNote64thUp("U+ECAD", null, "64th note (hemidemisemiquaver) stem up"),

  /// Eighth note (quaver) stem down.
  metNote8thDown("U+ECA8", null, "Eighth note (quaver) stem down"),

  /// Eighth note (quaver) stem up.
  metNote8thUp("U+ECA7", null, "Eighth note (quaver) stem up"),

  /// Double whole note (breve).
  metNoteDoubleWhole("U+ECA0", null, "Double whole note (breve)"),

  /// Double whole note (square).
  metNoteDoubleWholeSquare("U+ECA1", null, "Double whole note (square)"),

  /// Half note (minim) stem down.
  metNoteHalfDown("U+ECA4", null, "Half note (minim) stem down"),

  /// Half note (minim) stem up.
  metNoteHalfUp("U+ECA3", null, "Half note (minim) stem up"),

  /// Quarter note (crotchet) stem down.
  metNoteQuarterDown("U+ECA6", null, "Quarter note (crotchet) stem down"),

  /// Quarter note (crotchet) stem up.
  metNoteQuarterUp("U+ECA5", null, "Quarter note (crotchet) stem up"),

  /// Whole note (semibreve).
  metNoteWhole("U+ECA2", null, "Whole note (semibreve)"),

  /// Left-pointing arrow for metric modulation.
  metricModulationArrowLeft(
      "U+EC63", null, "Left-pointing arrow for metric modulation"),

  /// Right-pointing arrow for metric modulation.
  metricModulationArrowRight(
      "U+EC64", null, "Right-pointing arrow for metric modulation"),

  /// Do not copy.
  miscDoNotCopy("U+EC61", null, "Do not copy"),

  /// Do not photocopy.
  miscDoNotPhotocopy("U+EC60", null, "Do not photocopy"),

  /// Eyeglasses.
  miscEyeglasses("U+EC62", null, "Eyeglasses"),

  /// 1024th note (semihemidemisemihemidemisemiquaver) stem down.
  note1024thDown("U+E1E6", null,
      "1024th note (semihemidemisemihemidemisemiquaver) stem down"),

  /// 1024th note (semihemidemisemihemidemisemiquaver) stem up.
  note1024thUp("U+E1E5", null,
      "1024th note (semihemidemisemihemidemisemiquaver) stem up"),

  /// 128th note (semihemidemisemiquaver) stem down.
  note128thDown(
      "U+E1E0", null, "128th note (semihemidemisemiquaver) stem down"),

  /// 128th note (semihemidemisemiquaver) stem up.
  note128thUp(
      "U+E1DF", "U+1D164", "128th note (semihemidemisemiquaver) stem up"),

  /// 16th note (semiquaver) stem down.
  note16thDown("U+E1DA", null, "16th note (semiquaver) stem down"),

  /// 16th note (semiquaver) stem up.
  note16thUp("U+E1D9", "U+1D161", "16th note (semiquaver) stem up"),

  /// 256th note (demisemihemidemisemiquaver) stem down.
  note256thDown(
      "U+E1E2", null, "256th note (demisemihemidemisemiquaver) stem down"),

  /// 256th note (demisemihemidemisemiquaver) stem up.
  note256thUp(
      "U+E1E1", null, "256th note (demisemihemidemisemiquaver) stem up"),

  /// 32nd note (demisemiquaver) stem down.
  note32ndDown("U+E1DC", null, "32nd note (demisemiquaver) stem down"),

  /// 32nd note (demisemiquaver) stem up.
  note32ndUp("U+E1DB", "U+1D162", "32nd note (demisemiquaver) stem up"),

  /// 512th note (hemidemisemihemidemisemiquaver) stem down.
  note512thDown(
      "U+E1E4", null, "512th note (hemidemisemihemidemisemiquaver) stem down"),

  /// 512th note (hemidemisemihemidemisemiquaver) stem up.
  note512thUp(
      "U+E1E3", null, "512th note (hemidemisemihemidemisemiquaver) stem up"),

  /// 64th note (hemidemisemiquaver) stem down.
  note64thDown("U+E1DE", null, "64th note (hemidemisemiquaver) stem down"),

  /// 64th note (hemidemisemiquaver) stem up.
  note64thUp("U+E1DD", "U+1D163", "64th note (hemidemisemiquaver) stem up"),

  /// Eighth note (quaver) stem down.
  note8thDown("U+E1D8", null, "Eighth note (quaver) stem down"),

  /// Eighth note (quaver) stem up.
  note8thUp("U+E1D7", "U+1D160", "Eighth note (quaver) stem up"),

  /// A (black note).
  noteABlack("U+E197", null, "A (black note)"),

  /// A flat (black note).
  noteAFlatBlack("U+E196", null, "A flat (black note)"),

  /// A flat (half note).
  noteAFlatHalf("U+E17F", null, "A flat (half note)"),

  /// A flat (whole note).
  noteAFlatWhole("U+E168", null, "A flat (whole note)"),

  /// A (half note).
  noteAHalf("U+E180", null, "A (half note)"),

  /// A sharp (black note).
  noteASharpBlack("U+E198", null, "A sharp (black note)"),

  /// A sharp (half note).
  noteASharpHalf("U+E181", null, "A sharp (half note)"),

  /// A sharp (whole note).
  noteASharpWhole("U+E16A", null, "A sharp (whole note)"),

  /// A (whole note).
  noteAWhole("U+E169", null, "A (whole note)"),

  /// B (black note).
  noteBBlack("U+E19A", null, "B (black note)"),

  /// B flat (black note).
  noteBFlatBlack("U+E199", null, "B flat (black note)"),

  /// B flat (half note).
  noteBFlatHalf("U+E182", null, "B flat (half note)"),

  /// B flat (whole note).
  noteBFlatWhole("U+E16B", null, "B flat (whole note)"),

  /// B (half note).
  noteBHalf("U+E183", null, "B (half note)"),

  /// B sharp (black note).
  noteBSharpBlack("U+E19B", null, "B sharp (black note)"),

  /// B sharp (half note).
  noteBSharpHalf("U+E184", null, "B sharp (half note)"),

  /// B sharp (whole note).
  noteBSharpWhole("U+E16D", null, "B sharp (whole note)"),

  /// B (whole note).
  noteBWhole("U+E16C", null, "B (whole note)"),

  /// C (black note).
  noteCBlack("U+E19D", null, "C (black note)"),

  /// C flat (black note).
  noteCFlatBlack("U+E19C", null, "C flat (black note)"),

  /// C flat (half note).
  noteCFlatHalf("U+E185", null, "C flat (half note)"),

  /// C flat (whole note).
  noteCFlatWhole("U+E16E", null, "C flat (whole note)"),

  /// C (half note).
  noteCHalf("U+E186", null, "C (half note)"),

  /// C sharp (black note).
  noteCSharpBlack("U+E19E", null, "C sharp (black note)"),

  /// C sharp (half note).
  noteCSharpHalf("U+E187", null, "C sharp (half note)"),

  /// C sharp (whole note).
  noteCSharpWhole("U+E170", null, "C sharp (whole note)"),

  /// C (whole note).
  noteCWhole("U+E16F", null, "C (whole note)"),

  /// D (black note).
  noteDBlack("U+E1A0", null, "D (black note)"),

  /// D flat (black note).
  noteDFlatBlack("U+E19F", null, "D flat (black note)"),

  /// D flat (half note).
  noteDFlatHalf("U+E188", null, "D flat (half note)"),

  /// D flat (whole note).
  noteDFlatWhole("U+E171", null, "D flat (whole note)"),

  /// D (half note).
  noteDHalf("U+E189", null, "D (half note)"),

  /// D sharp (black note).
  noteDSharpBlack("U+E1A1", null, "D sharp (black note)"),

  /// D sharp (half note).
  noteDSharpHalf("U+E18A", null, "D sharp (half note)"),

  /// D sharp (whole note).
  noteDSharpWhole("U+E173", null, "D sharp (whole note)"),

  /// D (whole note).
  noteDWhole("U+E172", null, "D (whole note)"),

  /// Di (black note).
  noteDiBlack("U+EEF2", null, "Di (black note)"),

  /// Di (half note).
  noteDiHalf("U+EEE9", null, "Di (half note)"),

  /// Di (whole note).
  noteDiWhole("U+EEE0", null, "Di (whole note)"),

  /// Do (black note).
  noteDoBlack("U+E160", null, "Do (black note)"),

  /// Do (half note).
  noteDoHalf("U+E158", null, "Do (half note)"),

  /// Do (whole note).
  noteDoWhole("U+E150", null, "Do (whole note)"),

  /// Double whole note (breve).
  noteDoubleWhole("U+E1D0", "U+1D15C", "Double whole note (breve)"),

  /// Double whole note (square).
  noteDoubleWholeSquare("U+E1D1", null, "Double whole note (square)"),

  /// E (black note).
  noteEBlack("U+E1A3", null, "E (black note)"),

  /// E flat (black note).
  noteEFlatBlack("U+E1A2", null, "E flat (black note)"),

  /// E flat (half note).
  noteEFlatHalf("U+E18B", null, "E flat (half note)"),

  /// E flat (whole note).
  noteEFlatWhole("U+E174", null, "E flat (whole note)"),

  /// E (half note).
  noteEHalf("U+E18C", null, "E (half note)"),

  /// E sharp (black note).
  noteESharpBlack("U+E1A4", null, "E sharp (black note)"),

  /// E sharp (half note).
  noteESharpHalf("U+E18D", null, "E sharp (half note)"),

  /// E sharp (whole note).
  noteESharpWhole("U+E176", null, "E sharp (whole note)"),

  /// E (whole note).
  noteEWhole("U+E175", null, "E (whole note)"),

  /// Empty black note.
  noteEmptyBlack("U+E1AF", null, "Empty black note"),

  /// Empty half note.
  noteEmptyHalf("U+E1AE", null, "Empty half note"),

  /// Empty whole note.
  noteEmptyWhole("U+E1AD", null, "Empty whole note"),

  /// F (black note).
  noteFBlack("U+E1A6", null, "F (black note)"),

  /// F flat (black note).
  noteFFlatBlack("U+E1A5", null, "F flat (black note)"),

  /// F flat (half note).
  noteFFlatHalf("U+E18E", null, "F flat (half note)"),

  /// F flat (whole note).
  noteFFlatWhole("U+E177", null, "F flat (whole note)"),

  /// F (half note).
  noteFHalf("U+E18F", null, "F (half note)"),

  /// F sharp (black note).
  noteFSharpBlack("U+E1A7", null, "F sharp (black note)"),

  /// F sharp (half note).
  noteFSharpHalf("U+E190", null, "F sharp (half note)"),

  /// F sharp (whole note).
  noteFSharpWhole("U+E179", null, "F sharp (whole note)"),

  /// F (whole note).
  noteFWhole("U+E178", null, "F (whole note)"),

  /// Fa (black note).
  noteFaBlack("U+E163", null, "Fa (black note)"),

  /// Fa (half note).
  noteFaHalf("U+E15B", null, "Fa (half note)"),

  /// Fa (whole note).
  noteFaWhole("U+E153", null, "Fa (whole note)"),

  /// Fi (black note).
  noteFiBlack("U+EEF6", null, "Fi (black note)"),

  /// Fi (half note).
  noteFiHalf("U+EEED", null, "Fi (half note)"),

  /// Fi (whole note).
  noteFiWhole("U+EEE4", null, "Fi (whole note)"),

  /// G (black note).
  noteGBlack("U+E1A9", null, "G (black note)"),

  /// G flat (black note).
  noteGFlatBlack("U+E1A8", null, "G flat (black note)"),

  /// G flat (half note).
  noteGFlatHalf("U+E191", null, "G flat (half note)"),

  /// G flat (whole note).
  noteGFlatWhole("U+E17A", null, "G flat (whole note)"),

  /// G (half note).
  noteGHalf("U+E192", null, "G (half note)"),

  /// G sharp (black note).
  noteGSharpBlack("U+E1AA", null, "G sharp (black note)"),

  /// G sharp (half note).
  noteGSharpHalf("U+E193", null, "G sharp (half note)"),

  /// G sharp (whole note).
  noteGSharpWhole("U+E17C", null, "G sharp (whole note)"),

  /// G (whole note).
  noteGWhole("U+E17B", null, "G (whole note)"),

  /// H (black note).
  noteHBlack("U+E1AB", null, "H (black note)"),

  /// H (half note).
  noteHHalf("U+E194", null, "H (half note)"),

  /// H sharp (black note).
  noteHSharpBlack("U+E1AC", null, "H sharp (black note)"),

  /// H sharp (half note).
  noteHSharpHalf("U+E195", null, "H sharp (half note)"),

  /// H sharp (whole note).
  noteHSharpWhole("U+E17E", null, "H sharp (whole note)"),

  /// H (whole note).
  noteHWhole("U+E17D", null, "H (whole note)"),

  /// Half note (minim) stem down.
  noteHalfDown("U+E1D4", null, "Half note (minim) stem down"),

  /// Half note (minim) stem up.
  noteHalfUp("U+E1D3", "U+1D15E", "Half note (minim) stem up"),

  /// La (black note).
  noteLaBlack("U+E165", null, "La (black note)"),

  /// La (half note).
  noteLaHalf("U+E15D", null, "La (half note)"),

  /// La (whole note).
  noteLaWhole("U+E155", null, "La (whole note)"),

  /// Le (black note).
  noteLeBlack("U+EEF9", null, "Le (black note)"),

  /// Le (half note).
  noteLeHalf("U+EEF0", null, "Le (half note)"),

  /// Le (whole note).
  noteLeWhole("U+EEE7", null, "Le (whole note)"),

  /// Li (black note).
  noteLiBlack("U+EEF8", null, "Li (black note)"),

  /// Li (half note).
  noteLiHalf("U+EEEF", null, "Li (half note)"),

  /// Li (whole note).
  noteLiWhole("U+EEE6", null, "Li (whole note)"),

  /// Me (black note).
  noteMeBlack("U+EEF5", null, "Me (black note)"),

  /// Me (half note).
  noteMeHalf("U+EEEC", null, "Me (half note)"),

  /// Me (whole note).
  noteMeWhole("U+EEE3", null, "Me (whole note)"),

  /// Mi (black note).
  noteMiBlack("U+E162", null, "Mi (black note)"),

  /// Mi (half note).
  noteMiHalf("U+E15A", null, "Mi (half note)"),

  /// Mi (whole note).
  noteMiWhole("U+E152", null, "Mi (whole note)"),

  /// Quarter note (crotchet) stem down.
  noteQuarterDown("U+E1D6", null, "Quarter note (crotchet) stem down"),

  /// Quarter note (crotchet) stem up.
  noteQuarterUp("U+E1D5", "U+1D15F", "Quarter note (crotchet) stem up"),

  /// Ra (black note).
  noteRaBlack("U+EEF4", null, "Ra (black note)"),

  /// Ra (half note).
  noteRaHalf("U+EEEB", null, "Ra (half note)"),

  /// Ra (whole note).
  noteRaWhole("U+EEE2", null, "Ra (whole note)"),

  /// Re (black note).
  noteReBlack("U+E161", null, "Re (black note)"),

  /// Re (half note).
  noteReHalf("U+E159", null, "Re (half note)"),

  /// Re (whole note).
  noteReWhole("U+E151", null, "Re (whole note)"),

  /// Ri (black note).
  noteRiBlack("U+EEF3", null, "Ri (black note)"),

  /// Ri (half note).
  noteRiHalf("U+EEEA", null, "Ri (half note)"),

  /// Ri (whole note).
  noteRiWhole("U+EEE1", null, "Ri (whole note)"),

  /// Se (black note).
  noteSeBlack("U+EEF7", null, "Se (black note)"),

  /// Se (half note).
  noteSeHalf("U+EEEE", null, "Se (half note)"),

  /// Se (whole note).
  noteSeWhole("U+EEE5", null, "Se (whole note)"),

  /// Arrowhead left black (Funk 7-shape re).
  noteShapeArrowheadLeftBlack(
      "U+E1C9", null, "Arrowhead left black (Funk 7-shape re)"),

  /// Arrowhead left double whole (Funk 7-shape re).
  noteShapeArrowheadLeftDoubleWhole(
      "U+ECDC", null, "Arrowhead left double whole (Funk 7-shape re)"),

  /// Arrowhead left white (Funk 7-shape re).
  noteShapeArrowheadLeftWhite(
      "U+E1C8", null, "Arrowhead left white (Funk 7-shape re)"),

  /// Diamond black (4-shape mi; 7-shape mi).
  noteShapeDiamondBlack(
      "U+E1B9", null, "Diamond black (4-shape mi; 7-shape mi)"),

  /// Diamond double whole (4-shape mi; 7-shape mi).
  noteShapeDiamondDoubleWhole(
      "U+ECD4", null, "Diamond double whole (4-shape mi; 7-shape mi)"),

  /// Diamond white (4-shape mi; 7-shape mi).
  noteShapeDiamondWhite(
      "U+E1B8", null, "Diamond white (4-shape mi; 7-shape mi)"),

  /// Isosceles triangle black (Walker 7-shape ti).
  noteShapeIsoscelesTriangleBlack(
      "U+E1C5", null, "Isosceles triangle black (Walker 7-shape ti)"),

  /// Isosceles triangle double whole (Walker 7-shape ti).
  noteShapeIsoscelesTriangleDoubleWhole(
      "U+ECDA", null, "Isosceles triangle double whole (Walker 7-shape ti)"),

  /// Isosceles triangle white (Walker 7-shape ti).
  noteShapeIsoscelesTriangleWhite(
      "U+E1C4", null, "Isosceles triangle white (Walker 7-shape ti)"),

  /// Inverted keystone black (Walker 7-shape do).
  noteShapeKeystoneBlack(
      "U+E1C1", null, "Inverted keystone black (Walker 7-shape do)"),

  /// Inverted keystone double whole (Walker 7-shape do).
  noteShapeKeystoneDoubleWhole(
      "U+ECD8", null, "Inverted keystone double whole (Walker 7-shape do)"),

  /// Inverted keystone white (Walker 7-shape do).
  noteShapeKeystoneWhite(
      "U+E1C0", null, "Inverted keystone white (Walker 7-shape do)"),

  /// Moon black (Aikin 7-shape re).
  noteShapeMoonBlack("U+E1BD", null, "Moon black (Aikin 7-shape re)"),

  /// Moon double whole (Aikin 7-shape re).
  noteShapeMoonDoubleWhole(
      "U+ECD6", null, "Moon double whole (Aikin 7-shape re)"),

  /// Moon left black (Funk 7-shape do).
  noteShapeMoonLeftBlack("U+E1C7", null, "Moon left black (Funk 7-shape do)"),

  /// Moon left double whole (Funk 7-shape do).
  noteShapeMoonLeftDoubleWhole(
      "U+ECDB", null, "Moon left double whole (Funk 7-shape do)"),

  /// Moon left white (Funk 7-shape do).
  noteShapeMoonLeftWhite("U+E1C6", null, "Moon left white (Funk 7-shape do)"),

  /// Moon white (Aikin 7-shape re).
  noteShapeMoonWhite("U+E1BC", null, "Moon white (Aikin 7-shape re)"),

  /// Quarter moon black (Walker 7-shape re).
  noteShapeQuarterMoonBlack(
      "U+E1C3", null, "Quarter moon black (Walker 7-shape re)"),

  /// Quarter moon double whole (Walker 7-shape re).
  noteShapeQuarterMoonDoubleWhole(
      "U+ECD9", null, "Quarter moon double whole (Walker 7-shape re)"),

  /// Quarter moon white (Walker 7-shape re).
  noteShapeQuarterMoonWhite(
      "U+E1C2", null, "Quarter moon white (Walker 7-shape re)"),

  /// Round black (4-shape sol; 7-shape so).
  noteShapeRoundBlack("U+E1B1", null, "Round black (4-shape sol; 7-shape so)"),

  /// Round double whole (4-shape sol; 7-shape so).
  noteShapeRoundDoubleWhole(
      "U+ECD0", null, "Round double whole (4-shape sol; 7-shape so)"),

  /// Round white (4-shape sol; 7-shape so).
  noteShapeRoundWhite("U+E1B0", null, "Round white (4-shape sol; 7-shape so)"),

  /// Square black (4-shape la; Aikin 7-shape la).
  noteShapeSquareBlack(
      "U+E1B3", null, "Square black (4-shape la; Aikin 7-shape la)"),

  /// Square double whole (4-shape la; Aikin 7-shape la).
  noteShapeSquareDoubleWhole(
      "U+ECD1", null, "Square double whole (4-shape la; Aikin 7-shape la)"),

  /// Square white (4-shape la; Aikin 7-shape la).
  noteShapeSquareWhite(
      "U+E1B2", null, "Square white (4-shape la; Aikin 7-shape la)"),

  /// Triangle left black (stem up; 4-shape fa; 7-shape fa).
  noteShapeTriangleLeftBlack(
      "U+E1B7", null, "Triangle left black (stem up; 4-shape fa; 7-shape fa)"),

  /// Triangle left double whole (stem up; 4-shape fa; 7-shape fa).
  noteShapeTriangleLeftDoubleWhole("U+ECD3", null,
      "Triangle left double whole (stem up; 4-shape fa; 7-shape fa)"),

  /// Triangle left white (stem up; 4-shape fa; 7-shape fa).
  noteShapeTriangleLeftWhite(
      "U+E1B6", null, "Triangle left white (stem up; 4-shape fa; 7-shape fa)"),

  /// Triangle right black (stem down; 4-shape fa; 7-shape fa).
  noteShapeTriangleRightBlack("U+E1B5", null,
      "Triangle right black (stem down; 4-shape fa; 7-shape fa)"),

  /// Triangle right double whole (stem down; 4-shape fa; 7-shape fa).
  noteShapeTriangleRightDoubleWhole("U+ECD2", null,
      "Triangle right double whole (stem down; 4-shape fa; 7-shape fa)"),

  /// Triangle right white (stem down; 4-shape fa; 7-shape fa).
  noteShapeTriangleRightWhite("U+E1B4", null,
      "Triangle right white (stem down; 4-shape fa; 7-shape fa)"),

  /// Triangle-round black (Aikin 7-shape ti).
  noteShapeTriangleRoundBlack(
      "U+E1BF", null, "Triangle-round black (Aikin 7-shape ti)"),

  /// Triangle-round white (Aikin 7-shape ti).
  noteShapeTriangleRoundDoubleWhole(
      "U+ECD7", null, "Triangle-round white (Aikin 7-shape ti)"),

  /// Triangle-round left black (Funk 7-shape ti).
  noteShapeTriangleRoundLeftBlack(
      "U+E1CB", null, "Triangle-round left black (Funk 7-shape ti)"),

  /// Triangle-round left double whole (Funk 7-shape ti).
  noteShapeTriangleRoundLeftDoubleWhole(
      "U+ECDD", null, "Triangle-round left double whole (Funk 7-shape ti)"),

  /// Triangle-round left white (Funk 7-shape ti).
  noteShapeTriangleRoundLeftWhite(
      "U+E1CA", null, "Triangle-round left white (Funk 7-shape ti)"),

  /// Triangle-round white (Aikin 7-shape ti).
  noteShapeTriangleRoundWhite(
      "U+E1BE", null, "Triangle-round white (Aikin 7-shape ti)"),

  /// Triangle up black (Aikin 7-shape do).
  noteShapeTriangleUpBlack(
      "U+E1BB", null, "Triangle up black (Aikin 7-shape do)"),

  /// Triangle up double whole (Aikin 7-shape do).
  noteShapeTriangleUpDoubleWhole(
      "U+ECD5", null, "Triangle up double whole (Aikin 7-shape do)"),

  /// Triangle up white (Aikin 7-shape do).
  noteShapeTriangleUpWhite(
      "U+E1BA", null, "Triangle up white (Aikin 7-shape do)"),

  /// Si (black note).
  noteSiBlack("U+E167", null, "Si (black note)"),

  /// Si (half note).
  noteSiHalf("U+E15F", null, "Si (half note)"),

  /// Si (whole note).
  noteSiWhole("U+E157", null, "Si (whole note)"),

  /// So (black note).
  noteSoBlack("U+E164", null, "So (black note)"),

  /// So (half note).
  noteSoHalf("U+E15C", null, "So (half note)"),

  /// So (whole note).
  noteSoWhole("U+E154", null, "So (whole note)"),

  /// Te (black note).
  noteTeBlack("U+EEFA", null, "Te (black note)"),

  /// Te (half note).
  noteTeHalf("U+EEF1", null, "Te (half note)"),

  /// Te (whole note).
  noteTeWhole("U+EEE8", null, "Te (whole note)"),

  /// Ti (black note).
  noteTiBlack("U+E166", null, "Ti (black note)"),

  /// Ti (half note).
  noteTiHalf("U+E15E", null, "Ti (half note)"),

  /// Ti (whole note).
  noteTiWhole("U+E156", null, "Ti (whole note)"),

  /// Whole note (semibreve).
  noteWhole("U+E1D2", "U+1D15D", "Whole note (semibreve)"),

  /// Black notehead.
  noteheadBlack("U+E0A4", "U+1D158", "Black notehead"),

  /// Circle slash notehead.
  noteheadCircleSlash("U+E0F7", null, "Circle slash notehead"),

  /// Circle X notehead.
  noteheadCircleX("U+E0B3", "U+1D145", "Circle X notehead"),

  /// Circle X double whole.
  noteheadCircleXDoubleWhole("U+E0B0", null, "Circle X double whole"),

  /// Circle X half.
  noteheadCircleXHalf("U+E0B2", null, "Circle X half"),

  /// Circle X whole.
  noteheadCircleXWhole("U+E0B1", null, "Circle X whole"),

  /// Circled black notehead.
  noteheadCircledBlack("U+E0E4", null, "Circled black notehead"),

  /// Black notehead in large circle.
  noteheadCircledBlackLarge("U+E0E8", null, "Black notehead in large circle"),

  /// Circled double whole notehead.
  noteheadCircledDoubleWhole("U+E0E7", null, "Circled double whole notehead"),

  /// Double whole notehead in large circle.
  noteheadCircledDoubleWholeLarge(
      "U+E0EB", null, "Double whole notehead in large circle"),

  /// Circled half notehead.
  noteheadCircledHalf("U+E0E5", null, "Circled half notehead"),

  /// Half notehead in large circle.
  noteheadCircledHalfLarge("U+E0E9", null, "Half notehead in large circle"),

  /// Circled whole notehead.
  noteheadCircledWhole("U+E0E6", null, "Circled whole notehead"),

  /// Whole notehead in large circle.
  noteheadCircledWholeLarge("U+E0EA", null, "Whole notehead in large circle"),

  /// Cross notehead in large circle.
  noteheadCircledXLarge("U+E0EC", null, "Cross notehead in large circle"),

  /// Double whole note cluster, 2nd.
  noteheadClusterDoubleWhole2nd(
      "U+E124", null, "Double whole note cluster, 2nd"),

  /// Double whole note cluster, 3rd.
  noteheadClusterDoubleWhole3rd(
      "U+E128", null, "Double whole note cluster, 3rd"),

  /// Combining double whole note cluster, bottom.
  noteheadClusterDoubleWholeBottom(
      "U+E12E", null, "Combining double whole note cluster, bottom"),

  /// Combining double whole note cluster, middle.
  noteheadClusterDoubleWholeMiddle(
      "U+E12D", null, "Combining double whole note cluster, middle"),

  /// Combining double whole note cluster, top.
  noteheadClusterDoubleWholeTop(
      "U+E12C", null, "Combining double whole note cluster, top"),

  /// Half note cluster, 2nd.
  noteheadClusterHalf2nd("U+E126", null, "Half note cluster, 2nd"),

  /// Half note cluster, 3rd.
  noteheadClusterHalf3rd("U+E12A", null, "Half note cluster, 3rd"),

  /// Combining half note cluster, bottom.
  noteheadClusterHalfBottom(
      "U+E134", null, "Combining half note cluster, bottom"),

  /// Combining half note cluster, middle.
  noteheadClusterHalfMiddle(
      "U+E133", null, "Combining half note cluster, middle"),

  /// Combining half note cluster, top.
  noteheadClusterHalfTop("U+E132", null, "Combining half note cluster, top"),

  /// Quarter note cluster, 2nd.
  noteheadClusterQuarter2nd("U+E127", null, "Quarter note cluster, 2nd"),

  /// Quarter note cluster, 3rd.
  noteheadClusterQuarter3rd("U+E12B", null, "Quarter note cluster, 3rd"),

  /// Combining quarter note cluster, bottom.
  noteheadClusterQuarterBottom(
      "U+E137", null, "Combining quarter note cluster, bottom"),

  /// Combining quarter note cluster, middle.
  noteheadClusterQuarterMiddle(
      "U+E136", null, "Combining quarter note cluster, middle"),

  /// Combining quarter note cluster, top.
  noteheadClusterQuarterTop(
      "U+E135", null, "Combining quarter note cluster, top"),

  /// Cluster notehead black (round).
  noteheadClusterRoundBlack("U+E123", null, "Cluster notehead black (round)"),

  /// Cluster notehead white (round).
  noteheadClusterRoundWhite("U+E122", null, "Cluster notehead white (round)"),

  /// Cluster notehead black (square).
  noteheadClusterSquareBlack(
      "U+E121", "U+1D15B", "Cluster notehead black (square)"),

  /// Cluster notehead white (square).
  noteheadClusterSquareWhite(
      "U+E120", "U+1D15A", "Cluster notehead white (square)"),

  /// Whole note cluster, 2nd.
  noteheadClusterWhole2nd("U+E125", null, "Whole note cluster, 2nd"),

  /// Whole note cluster, 3rd.
  noteheadClusterWhole3rd("U+E129", null, "Whole note cluster, 3rd"),

  /// Combining whole note cluster, bottom.
  noteheadClusterWholeBottom(
      "U+E131", null, "Combining whole note cluster, bottom"),

  /// Combining whole note cluster, middle.
  noteheadClusterWholeMiddle(
      "U+E130", null, "Combining whole note cluster, middle"),

  /// Combining whole note cluster, top.
  noteheadClusterWholeTop("U+E12F", null, "Combining whole note cluster, top"),

  /// 4/11 note (eleventh note series, Cowell).
  noteheadCowellEleventhNoteSeriesHalf(
      "U+EEAE", null, "4/11 note (eleventh note series, Cowell)"),

  /// 8/11 note (eleventh note series, Cowell).
  noteheadCowellEleventhNoteSeriesWhole(
      "U+EEAD", null, "8/11 note (eleventh note series, Cowell)"),

  /// 2/11 note (eleventh note series, Cowell).
  noteheadCowellEleventhSeriesBlack(
      "U+EEAF", null, "2/11 note (eleventh note series, Cowell)"),

  /// 2/15 note (fifteenth note series, Cowell).
  noteheadCowellFifteenthNoteSeriesBlack(
      "U+EEB5", null, "2/15 note (fifteenth note series, Cowell)"),

  /// 4/15 note (fifteenth note series, Cowell).
  noteheadCowellFifteenthNoteSeriesHalf(
      "U+EEB4", null, "4/15 note (fifteenth note series, Cowell)"),

  /// 8/15 note (fifteenth note series, Cowell).
  noteheadCowellFifteenthNoteSeriesWhole(
      "U+EEB3", null, "8/15 note (fifteenth note series, Cowell)"),

  /// 1/5 note (fifth note series, Cowell).
  noteheadCowellFifthNoteSeriesBlack(
      "U+EEA6", null, "1/5 note (fifth note series, Cowell)"),

  /// 2/5 note (fifth note series, Cowell).
  noteheadCowellFifthNoteSeriesHalf(
      "U+EEA5", null, "2/5 note (fifth note series, Cowell)"),

  /// 4/5 note (fifth note series, Cowell).
  noteheadCowellFifthNoteSeriesWhole(
      "U+EEA4", null, "4/5 note (fifth note series, Cowell)"),

  /// 2/9 note (ninth note series, Cowell).
  noteheadCowellNinthNoteSeriesBlack(
      "U+EEAC", null, "2/9 note (ninth note series, Cowell)"),

  /// 4/9 note (ninth note series, Cowell).
  noteheadCowellNinthNoteSeriesHalf(
      "U+EEAB", null, "4/9 note (ninth note series, Cowell)"),

  /// 8/9 note (ninth note series, Cowell).
  noteheadCowellNinthNoteSeriesWhole(
      "U+EEAA", null, "8/9 note (ninth note series, Cowell)"),

  /// 1/7 note (seventh note series, Cowell).
  noteheadCowellSeventhNoteSeriesBlack(
      "U+EEA9", null, "1/7 note (seventh note series, Cowell)"),

  /// 2/7 note (seventh note series, Cowell).
  noteheadCowellSeventhNoteSeriesHalf(
      "U+EEA8", null, "2/7 note (seventh note series, Cowell)"),

  /// 4/7 note (seventh note series, Cowell).
  noteheadCowellSeventhNoteSeriesWhole(
      "U+EEA7", null, "4/7 note (seventh note series, Cowell)"),

  /// 1/6 note (third note series, Cowell).
  noteheadCowellThirdNoteSeriesBlack(
      "U+EEA3", null, "1/6 note (third note series, Cowell)"),

  /// 1/3 note (third note series, Cowell).
  noteheadCowellThirdNoteSeriesHalf(
      "U+EEA2", null, "1/3 note (third note series, Cowell)"),

  /// 2/3 note (third note series, Cowell).
  noteheadCowellThirdNoteSeriesWhole(
      "U+EEA1", null, "2/3 note (third note series, Cowell)"),

  /// 2/13 note (thirteenth note series, Cowell).
  noteheadCowellThirteenthNoteSeriesBlack(
      "U+EEB2", null, "2/13 note (thirteenth note series, Cowell)"),

  /// 4/13 note (thirteenth note series, Cowell).
  noteheadCowellThirteenthNoteSeriesHalf(
      "U+EEB1", null, "4/13 note (thirteenth note series, Cowell)"),

  /// 8/13 note (thirteenth note series, Cowell).
  noteheadCowellThirteenthNoteSeriesWhole(
      "U+EEB0", null, "8/13 note (thirteenth note series, Cowell)"),

  /// Diamond black notehead.
  noteheadDiamondBlack("U+E0DB", null, "Diamond black notehead"),

  /// Diamond black notehead (old).
  noteheadDiamondBlackOld("U+E0E2", null, "Diamond black notehead (old)"),

  /// Diamond black notehead (wide).
  noteheadDiamondBlackWide("U+E0DC", null, "Diamond black notehead (wide)"),

  /// Black diamond cluster, 2nd.
  noteheadDiamondClusterBlack2nd("U+E139", null, "Black diamond cluster, 2nd"),

  /// Black diamond cluster, 3rd.
  noteheadDiamondClusterBlack3rd("U+E13B", null, "Black diamond cluster, 3rd"),

  /// Combining black diamond cluster, bottom.
  noteheadDiamondClusterBlackBottom(
      "U+E141", null, "Combining black diamond cluster, bottom"),

  /// Combining black diamond cluster, middle.
  noteheadDiamondClusterBlackMiddle(
      "U+E140", null, "Combining black diamond cluster, middle"),

  /// Combining black diamond cluster, top.
  noteheadDiamondClusterBlackTop(
      "U+E13F", null, "Combining black diamond cluster, top"),

  /// White diamond cluster, 2nd.
  noteheadDiamondClusterWhite2nd("U+E138", null, "White diamond cluster, 2nd"),

  /// White diamond cluster, 3rd.
  noteheadDiamondClusterWhite3rd("U+E13A", null, "White diamond cluster, 3rd"),

  /// Combining white diamond cluster, bottom.
  noteheadDiamondClusterWhiteBottom(
      "U+E13E", null, "Combining white diamond cluster, bottom"),

  /// Combining white diamond cluster, middle.
  noteheadDiamondClusterWhiteMiddle(
      "U+E13D", null, "Combining white diamond cluster, middle"),

  /// Combining white diamond cluster, top.
  noteheadDiamondClusterWhiteTop(
      "U+E13C", null, "Combining white diamond cluster, top"),

  /// Diamond double whole notehead.
  noteheadDiamondDoubleWhole("U+E0D7", null, "Diamond double whole notehead"),

  /// Diamond double whole notehead (old).
  noteheadDiamondDoubleWholeOld(
      "U+E0DF", null, "Diamond double whole notehead (old)"),

  /// Diamond half notehead.
  noteheadDiamondHalf("U+E0D9", null, "Diamond half notehead"),

  /// Half-filled diamond notehead.
  noteheadDiamondHalfFilled("U+E0E3", null, "Half-filled diamond notehead"),

  /// Diamond half notehead (old).
  noteheadDiamondHalfOld("U+E0E1", null, "Diamond half notehead (old)"),

  /// Diamond half notehead (wide).
  noteheadDiamondHalfWide("U+E0DA", null, "Diamond half notehead (wide)"),

  /// Open diamond notehead.
  noteheadDiamondOpen("U+E0FC", null, "Open diamond notehead"),

  /// Diamond white notehead.
  noteheadDiamondWhite("U+E0DD", null, "Diamond white notehead"),

  /// Diamond white notehead (wide).
  noteheadDiamondWhiteWide("U+E0DE", null, "Diamond white notehead (wide)"),

  /// Diamond whole notehead.
  noteheadDiamondWhole("U+E0D8", null, "Diamond whole notehead"),

  /// Diamond whole notehead (old).
  noteheadDiamondWholeOld("U+E0E0", null, "Diamond whole notehead (old)"),

  /// Double whole (breve) notehead.
  noteheadDoubleWhole("U+E0A0", null, "Double whole (breve) notehead"),

  /// Double whole (breve) notehead (square).
  noteheadDoubleWholeSquare(
      "U+E0A1", null, "Double whole (breve) notehead (square)"),

  /// Double whole notehead with X.
  noteheadDoubleWholeWithX("U+E0B4", null, "Double whole notehead with X"),

  /// Half (minim) notehead.
  noteheadHalf("U+E0A3", "U+1D157", "Half (minim) notehead"),

  /// Filled half (minim) notehead.
  noteheadHalfFilled("U+E0FB", null, "Filled half (minim) notehead"),

  /// Half notehead with X.
  noteheadHalfWithX("U+E0B6", null, "Half notehead with X"),

  /// Heavy X notehead.
  noteheadHeavyX("U+E0F8", null, "Heavy X notehead"),

  /// Heavy X with hat notehead.
  noteheadHeavyXHat("U+E0F9", null, "Heavy X with hat notehead"),

  /// Large arrow down (lowest pitch) black notehead.
  noteheadLargeArrowDownBlack(
      "U+E0F4", null, "Large arrow down (lowest pitch) black notehead"),

  /// Large arrow down (lowest pitch) double whole notehead.
  noteheadLargeArrowDownDoubleWhole(
      "U+E0F1", null, "Large arrow down (lowest pitch) double whole notehead"),

  /// Large arrow down (lowest pitch) half notehead.
  noteheadLargeArrowDownHalf(
      "U+E0F3", null, "Large arrow down (lowest pitch) half notehead"),

  /// Large arrow down (lowest pitch) whole notehead.
  noteheadLargeArrowDownWhole(
      "U+E0F2", null, "Large arrow down (lowest pitch) whole notehead"),

  /// Large arrow up (highest pitch) black notehead.
  noteheadLargeArrowUpBlack(
      "U+E0F0", null, "Large arrow up (highest pitch) black notehead"),

  /// Large arrow up (highest pitch) double whole notehead.
  noteheadLargeArrowUpDoubleWhole(
      "U+E0ED", null, "Large arrow up (highest pitch) double whole notehead"),

  /// Large arrow up (highest pitch) half notehead.
  noteheadLargeArrowUpHalf(
      "U+E0EF", null, "Large arrow up (highest pitch) half notehead"),

  /// Large arrow up (highest pitch) whole notehead.
  noteheadLargeArrowUpWhole(
      "U+E0EE", null, "Large arrow up (highest pitch) whole notehead"),

  /// Moon notehead black.
  noteheadMoonBlack("U+E0CB", "U+1D153", "Moon notehead black"),

  /// Moon notehead white.
  noteheadMoonWhite("U+E0CA", "U+1D152", "Moon notehead white"),

  /// Sine notehead (Nancarrow).
  noteheadNancarrowSine("U+EEA0", null, "Sine notehead (Nancarrow)"),

  /// Null notehead.
  noteheadNull("U+E0A5", "U+1D159", "Null notehead"),

  /// Parenthesis notehead.
  noteheadParenthesis("U+E0CE", "U+1D156", "Parenthesis notehead"),

  /// Opening parenthesis.
  noteheadParenthesisLeft("U+E0F5", null, "Opening parenthesis"),

  /// Closing parenthesis.
  noteheadParenthesisRight("U+E0F6", null, "Closing parenthesis"),

  /// Plus notehead black.
  noteheadPlusBlack("U+E0AF", "U+1D144", "Plus notehead black"),

  /// Plus notehead double whole.
  noteheadPlusDoubleWhole("U+E0AC", null, "Plus notehead double whole"),

  /// Plus notehead half.
  noteheadPlusHalf("U+E0AE", null, "Plus notehead half"),

  /// Plus notehead whole.
  noteheadPlusWhole("U+E0AD", null, "Plus notehead whole"),

  /// Combining black rectangular cluster, bottom.
  noteheadRectangularClusterBlackBottom(
      "U+E144", null, "Combining black rectangular cluster, bottom"),

  /// Combining black rectangular cluster, middle.
  noteheadRectangularClusterBlackMiddle(
      "U+E143", null, "Combining black rectangular cluster, middle"),

  /// Combining black rectangular cluster, top.
  noteheadRectangularClusterBlackTop(
      "U+E142", null, "Combining black rectangular cluster, top"),

  /// Combining white rectangular cluster, bottom.
  noteheadRectangularClusterWhiteBottom(
      "U+E147", null, "Combining white rectangular cluster, bottom"),

  /// Combining white rectangular cluster, middle.
  noteheadRectangularClusterWhiteMiddle(
      "U+E146", null, "Combining white rectangular cluster, middle"),

  /// Combining white rectangular cluster, top.
  noteheadRectangularClusterWhiteTop(
      "U+E145", null, "Combining white rectangular cluster, top"),

  /// Round black notehead.
  noteheadRoundBlack("U+E113", null, "Round black notehead"),

  /// Round black notehead, double slashed.
  noteheadRoundBlackDoubleSlashed(
      "U+E11C", null, "Round black notehead, double slashed"),

  /// Large round black notehead.
  noteheadRoundBlackLarge("U+E110", null, "Large round black notehead"),

  /// Round black notehead, slashed.
  noteheadRoundBlackSlashed("U+E118", null, "Round black notehead, slashed"),

  /// Large round black notehead, slashed.
  noteheadRoundBlackSlashedLarge(
      "U+E116", null, "Large round black notehead, slashed"),

  /// Round white notehead.
  noteheadRoundWhite("U+E114", null, "Round white notehead"),

  /// Round white notehead, double slashed.
  noteheadRoundWhiteDoubleSlashed(
      "U+E11D", null, "Round white notehead, double slashed"),

  /// Large round white notehead.
  noteheadRoundWhiteLarge("U+E111", null, "Large round white notehead"),

  /// Round white notehead, slashed.
  noteheadRoundWhiteSlashed("U+E119", null, "Round white notehead, slashed"),

  /// Large round white notehead, slashed.
  noteheadRoundWhiteSlashedLarge(
      "U+E117", null, "Large round white notehead, slashed"),

  /// Round white notehead with dot.
  noteheadRoundWhiteWithDot("U+E115", null, "Round white notehead with dot"),

  /// Large round white notehead with dot.
  noteheadRoundWhiteWithDotLarge(
      "U+E112", null, "Large round white notehead with dot"),

  /// Large white diamond.
  noteheadSlashDiamondWhite("U+E104", null, "Large white diamond"),

  /// Slash with horizontal ends.
  noteheadSlashHorizontalEnds(
      "U+E101", "U+1D10D", "Slash with horizontal ends"),

  /// Muted slash with horizontal ends.
  noteheadSlashHorizontalEndsMuted(
      "U+E108", null, "Muted slash with horizontal ends"),

  /// Slash with vertical ends.
  noteheadSlashVerticalEnds("U+E100", null, "Slash with vertical ends"),

  /// Muted slash with vertical ends.
  noteheadSlashVerticalEndsMuted(
      "U+E107", null, "Muted slash with vertical ends"),

  /// Small slash with vertical ends.
  noteheadSlashVerticalEndsSmall(
      "U+E105", null, "Small slash with vertical ends"),

  /// White slash double whole.
  noteheadSlashWhiteDoubleWhole("U+E10A", null, "White slash double whole"),

  /// White slash half.
  noteheadSlashWhiteHalf("U+E103", null, "White slash half"),

  /// Muted white slash.
  noteheadSlashWhiteMuted("U+E109", null, "Muted white slash"),

  /// White slash whole.
  noteheadSlashWhiteWhole("U+E102", null, "White slash whole"),

  /// Large X notehead.
  noteheadSlashX("U+E106", null, "Large X notehead"),

  /// Slashed black notehead (bottom left to top right).
  noteheadSlashedBlack1(
      "U+E0CF", null, "Slashed black notehead (bottom left to top right)"),

  /// Slashed black notehead (top left to bottom right).
  noteheadSlashedBlack2(
      "U+E0D0", null, "Slashed black notehead (top left to bottom right)"),

  /// Slashed double whole notehead (bottom left to top right).
  noteheadSlashedDoubleWhole1("U+E0D5", null,
      "Slashed double whole notehead (bottom left to top right)"),

  /// Slashed double whole notehead (top left to bottom right).
  noteheadSlashedDoubleWhole2("U+E0D6", null,
      "Slashed double whole notehead (top left to bottom right)"),

  /// Slashed half notehead (bottom left to top right).
  noteheadSlashedHalf1(
      "U+E0D1", null, "Slashed half notehead (bottom left to top right)"),

  /// Slashed half notehead (top left to bottom right).
  noteheadSlashedHalf2(
      "U+E0D2", null, "Slashed half notehead (top left to bottom right)"),

  /// Slashed whole notehead (bottom left to top right).
  noteheadSlashedWhole1(
      "U+E0D3", null, "Slashed whole notehead (bottom left to top right)"),

  /// Slashed whole notehead (top left to bottom right).
  noteheadSlashedWhole2(
      "U+E0D4", null, "Slashed whole notehead (top left to bottom right)"),

  /// Square notehead black.
  noteheadSquareBlack("U+E0B9", "U+1D147", "Square notehead black"),

  /// Large square black notehead.
  noteheadSquareBlackLarge("U+E11A", null, "Large square black notehead"),

  /// Large square white notehead.
  noteheadSquareBlackWhite("U+E11B", null, "Large square white notehead"),

  /// Square notehead white.
  noteheadSquareWhite("U+E0B8", "U+1D146", "Square notehead white"),

  /// Triangle notehead down black.
  noteheadTriangleDownBlack(
      "U+E0C7", "U+1D14F", "Triangle notehead down black"),

  /// Triangle notehead down double whole.
  noteheadTriangleDownDoubleWhole(
      "U+E0C3", null, "Triangle notehead down double whole"),

  /// Triangle notehead down half.
  noteheadTriangleDownHalf("U+E0C5", null, "Triangle notehead down half"),

  /// Triangle notehead down white.
  noteheadTriangleDownWhite(
      "U+E0C6", "U+1D14E", "Triangle notehead down white"),

  /// Triangle notehead down whole.
  noteheadTriangleDownWhole("U+E0C4", null, "Triangle notehead down whole"),

  /// Triangle notehead left black.
  noteheadTriangleLeftBlack(
      "U+E0C0", "U+1D14B", "Triangle notehead left black"),

  /// Triangle notehead left white.
  noteheadTriangleLeftWhite(
      "U+E0BF", "U+1D14A", "Triangle notehead left white"),

  /// Triangle notehead right black.
  noteheadTriangleRightBlack(
      "U+E0C2", "U+1D14D", "Triangle notehead right black"),

  /// Triangle notehead right white.
  noteheadTriangleRightWhite(
      "U+E0C1", "U+1D14C", "Triangle notehead right white"),

  /// Triangle-round notehead down black.
  noteheadTriangleRoundDownBlack(
      "U+E0CD", "U+1D155", "Triangle-round notehead down black"),

  /// Triangle-round notehead down white.
  noteheadTriangleRoundDownWhite(
      "U+E0CC", "U+1D154", "Triangle-round notehead down white"),

  /// Triangle notehead up black.
  noteheadTriangleUpBlack("U+E0BE", "U+1D149", "Triangle notehead up black"),

  /// Triangle notehead up double whole.
  noteheadTriangleUpDoubleWhole(
      "U+E0BA", null, "Triangle notehead up double whole"),

  /// Triangle notehead up half.
  noteheadTriangleUpHalf("U+E0BC", null, "Triangle notehead up half"),

  /// Triangle notehead up right black.
  noteheadTriangleUpRightBlack(
      "U+E0C9", "U+1D151", "Triangle notehead up right black"),

  /// Triangle notehead up right white.
  noteheadTriangleUpRightWhite(
      "U+E0C8", "U+1D150", "Triangle notehead up right white"),

  /// Triangle notehead up white.
  noteheadTriangleUpWhite("U+E0BD", "U+1D148", "Triangle notehead up white"),

  /// Triangle notehead up whole.
  noteheadTriangleUpWhole("U+E0BB", null, "Triangle notehead up whole"),

  /// Void notehead with X.
  noteheadVoidWithX("U+E0B7", null, "Void notehead with X"),

  /// Whole (semibreve) notehead.
  noteheadWhole("U+E0A2", null, "Whole (semibreve) notehead"),

  /// Filled whole (semibreve) notehead.
  noteheadWholeFilled("U+E0FA", null, "Filled whole (semibreve) notehead"),

  /// Whole notehead with X.
  noteheadWholeWithX("U+E0B5", null, "Whole notehead with X"),

  /// X notehead black.
  noteheadXBlack("U+E0A9", "U+1D143", "X notehead black"),

  /// X notehead double whole.
  noteheadXDoubleWhole("U+E0A6", null, "X notehead double whole"),

  /// X notehead half.
  noteheadXHalf("U+E0A8", null, "X notehead half"),

  /// Ornate X notehead.
  noteheadXOrnate("U+E0AA", null, "Ornate X notehead"),

  /// Ornate X notehead in ellipse.
  noteheadXOrnateEllipse("U+E0AB", null, "Ornate X notehead in ellipse"),

  /// X notehead whole.
  noteheadXWhole("U+E0A7", null, "X notehead whole"),

  /// a (baseline).
  octaveBaselineA("U+EC91", null, "a (baseline)"),

  /// b (baseline).
  octaveBaselineB("U+EC93", null, "b (baseline)"),

  /// m (baseline).
  octaveBaselineM("U+EC95", null, "m (baseline)"),

  /// v (baseline).
  octaveBaselineV("U+EC97", null, "v (baseline)"),

  /// Bassa.
  octaveBassa("U+E51F", null, "Bassa"),

  /// Loco.
  octaveLoco("U+EC90", null, "Loco"),

  /// Left parenthesis for octave signs.
  octaveParensLeft("U+E51A", null, "Left parenthesis for octave signs"),

  /// Right parenthesis for octave signs.
  octaveParensRight("U+E51B", null, "Right parenthesis for octave signs"),

  /// a (superscript).
  octaveSuperscriptA("U+EC92", null, "a (superscript)"),

  /// b (superscript).
  octaveSuperscriptB("U+EC94", null, "b (superscript)"),

  /// m (superscript).
  octaveSuperscriptM("U+EC96", null, "m (superscript)"),

  /// v (superscript).
  octaveSuperscriptV("U+EC98", null, "v (superscript)"),

  /// One-handed roll (Stevens).
  oneHandedRollStevens("U+E233", null, "One-handed roll (Stevens)"),

  /// Two Fusae.
  organGerman2Fusae("U+EE2E", null, "Two Fusae"),

  /// Two Minimae.
  organGerman2Minimae("U+EE2C", null, "Two Minimae"),

  /// Combining double octave line above.
  organGerman2OctaveUp("U+EE19", null, "Combining double octave line above"),

  /// Two Semifusae.
  organGerman2Semifusae("U+EE2F", null, "Two Semifusae"),

  /// Two Semiminimae.
  organGerman2Semiminimae("U+EE2D", null, "Two Semiminimae"),

  /// Three Fusae.
  organGerman3Fusae("U+EE32", null, "Three Fusae"),

  /// Three Minimae.
  organGerman3Minimae("U+EE30", null, "Three Minimae"),

  /// Three Semifusae.
  organGerman3Semifusae("U+EE33", null, "Three Semifusae"),

  /// Three Semiminimae.
  organGerman3Semiminimae("U+EE31", null, "Three Semiminimae"),

  /// Four Fusae.
  organGerman4Fusae("U+EE36", null, "Four Fusae"),

  /// Four Minimae.
  organGerman4Minimae("U+EE34", null, "Four Minimae"),

  /// Four Semifusae.
  organGerman4Semifusae("U+EE37", null, "Four Semifusae"),

  /// Four Semiminimae.
  organGerman4Semiminimae("U+EE35", null, "Four Semiminimae"),

  /// Five Fusae.
  organGerman5Fusae("U+EE3A", null, "Five Fusae"),

  /// Five Minimae.
  organGerman5Minimae("U+EE38", null, "Five Minimae"),

  /// Five Semifusae.
  organGerman5Semifusae("U+EE3B", null, "Five Semifusae"),

  /// Five Semiminimae.
  organGerman5Semiminimae("U+EE39", null, "Five Semiminimae"),

  /// Six Fusae.
  organGerman6Fusae("U+EE3E", null, "Six Fusae"),

  /// Six Minimae.
  organGerman6Minimae("U+EE3C", null, "Six Minimae"),

  /// Six Semifusae.
  organGerman6Semifusae("U+EE3F", null, "Six Semifusae"),

  /// Six Semiminimae.
  organGerman6Semiminimae("U+EE3D", null, "Six Semiminimae"),

  /// German organ tablature small A.
  organGermanALower("U+EE15", null, "German organ tablature small A"),

  /// German organ tablature great A.
  organGermanAUpper("U+EE09", null, "German organ tablature great A"),

  /// Rhythm Dot.
  organGermanAugmentationDot("U+EE1C", null, "Rhythm Dot"),

  /// German organ tablature small B.
  organGermanBLower("U+EE16", null, "German organ tablature small B"),

  /// German organ tablature great B.
  organGermanBUpper("U+EE0A", null, "German organ tablature great B"),

  /// Brevis (Binary) Buxheimer Orgelbuch.
  organGermanBuxheimerBrevis2(
      "U+EE25", null, "Brevis (Binary) Buxheimer Orgelbuch"),

  /// Brevis (Ternary) Buxheimer Orgelbuch.
  organGermanBuxheimerBrevis3(
      "U+EE24", null, "Brevis (Ternary) Buxheimer Orgelbuch"),

  /// Minima Rest Buxheimer Orgelbuch.
  organGermanBuxheimerMinimaRest(
      "U+EE1E", null, "Minima Rest Buxheimer Orgelbuch"),

  /// Semibrevis Buxheimer Orgelbuch.
  organGermanBuxheimerSemibrevis(
      "U+EE26", null, "Semibrevis Buxheimer Orgelbuch"),

  /// Semibrevis Rest Buxheimer Orgelbuch.
  organGermanBuxheimerSemibrevisRest(
      "U+EE1D", null, "Semibrevis Rest Buxheimer Orgelbuch"),

  /// German organ tablature small C.
  organGermanCLower("U+EE0C", null, "German organ tablature small C"),

  /// German organ tablature great C.
  organGermanCUpper("U+EE00", null, "German organ tablature great C"),

  /// German organ tablature small Cis.
  organGermanCisLower("U+EE0D", null, "German organ tablature small Cis"),

  /// German organ tablature great Cis.
  organGermanCisUpper("U+EE01", null, "German organ tablature great Cis"),

  /// German organ tablature small D.
  organGermanDLower("U+EE0E", null, "German organ tablature small D"),

  /// German organ tablature great D.
  organGermanDUpper("U+EE02", null, "German organ tablature great D"),

  /// German organ tablature small Dis.
  organGermanDisLower("U+EE0F", null, "German organ tablature small Dis"),

  /// German organ tablature great Dis.
  organGermanDisUpper("U+EE03", null, "German organ tablature great Dis"),

  /// German organ tablature small E.
  organGermanELower("U+EE10", null, "German organ tablature small E"),

  /// German organ tablature great E.
  organGermanEUpper("U+EE04", null, "German organ tablature great E"),

  /// German organ tablature small F.
  organGermanFLower("U+EE11", null, "German organ tablature small F"),

  /// German organ tablature great F.
  organGermanFUpper("U+EE05", null, "German organ tablature great F"),

  /// German organ tablature small Fis.
  organGermanFisLower("U+EE12", null, "German organ tablature small Fis"),

  /// German organ tablature great Fis.
  organGermanFisUpper("U+EE06", null, "German organ tablature great Fis"),

  /// Fusa.
  organGermanFusa("U+EE2A", null, "Fusa"),

  /// Fusa Rest.
  organGermanFusaRest("U+EE22", null, "Fusa Rest"),

  /// German organ tablature small G.
  organGermanGLower("U+EE13", null, "German organ tablature small G"),

  /// German organ tablature great G.
  organGermanGUpper("U+EE07", null, "German organ tablature great G"),

  /// German organ tablature small Gis.
  organGermanGisLower("U+EE14", null, "German organ tablature small Gis"),

  /// German organ tablature great Gis.
  organGermanGisUpper("U+EE08", null, "German organ tablature great Gis"),

  /// German organ tablature small H.
  organGermanHLower("U+EE17", null, "German organ tablature small H"),

  /// German organ tablature great H.
  organGermanHUpper("U+EE0B", null, "German organ tablature great H"),

  /// Minima.
  organGermanMinima("U+EE28", null, "Minima"),

  /// Minima Rest.
  organGermanMinimaRest("U+EE20", null, "Minima Rest"),

  /// Combining single octave line below.
  organGermanOctaveDown("U+EE1A", null, "Combining single octave line below"),

  /// Combining single octave line above.
  organGermanOctaveUp("U+EE18", null, "Combining single octave line above"),

  /// Semibrevis.
  organGermanSemibrevis("U+EE27", null, "Semibrevis"),

  /// Semibrevis Rest.
  organGermanSemibrevisRest("U+EE1F", null, "Semibrevis Rest"),

  /// Semifusa.
  organGermanSemifusa("U+EE2B", null, "Semifusa"),

  /// Semifusa Rest.
  organGermanSemifusaRest("U+EE23", null, "Semifusa Rest"),

  /// Semiminima.
  organGermanSemiminima("U+EE29", null, "Semiminima"),

  /// Semiminima Rest.
  organGermanSemiminimaRest("U+EE21", null, "Semiminima Rest"),

  /// Tie.
  organGermanTie("U+EE1B", null, "Tie"),

  /// Ornament bottom left concave stroke.
  ornamentBottomLeftConcaveStroke(
      "U+E59A", null, "Ornament bottom left concave stroke"),

  /// Ornament bottom left concave stroke, large.
  ornamentBottomLeftConcaveStrokeLarge(
      "U+E59B", "U+1D1A1", "Ornament bottom left concave stroke, large"),

  /// Ornament bottom left convex stroke.
  ornamentBottomLeftConvexStroke(
      "U+E59C", null, "Ornament bottom left convex stroke"),

  /// Ornament bottom right concave stroke.
  ornamentBottomRightConcaveStroke(
      "U+E5A7", "U+1D19F", "Ornament bottom right concave stroke"),

  /// Ornament bottom right convex stroke.
  ornamentBottomRightConvexStroke(
      "U+E5A8", null, "Ornament bottom right convex stroke"),

  /// Comma.
  ornamentComma("U+E581", null, "Comma"),

  /// Double oblique straight lines NW-SE.
  ornamentDoubleObliqueLinesAfterNote(
      "U+E57E", null, "Double oblique straight lines NW-SE"),

  /// Double oblique straight lines SW-NE.
  ornamentDoubleObliqueLinesBeforeNote(
      "U+E57D", null, "Double oblique straight lines SW-NE"),

  /// Curve below.
  ornamentDownCurve("U+E578", null, "Curve below"),

  /// Haydn ornament.
  ornamentHaydn("U+E56F", null, "Haydn ornament"),

  /// Ornament high left concave stroke.
  ornamentHighLeftConcaveStroke(
      "U+E592", null, "Ornament high left concave stroke"),

  /// Ornament high left convex stroke.
  ornamentHighLeftConvexStroke(
      "U+E593", "U+1D1A2", "Ornament high left convex stroke"),

  /// Ornament high right concave stroke.
  ornamentHighRightConcaveStroke(
      "U+E5A2", null, "Ornament high right concave stroke"),

  /// Ornament high right convex stroke.
  ornamentHighRightConvexStroke(
      "U+E5A3", null, "Ornament high right convex stroke"),

  /// Hook after note.
  ornamentHookAfterNote("U+E576", null, "Hook after note"),

  /// Hook before note.
  ornamentHookBeforeNote("U+E575", null, "Hook before note"),

  /// Left-facing half circle.
  ornamentLeftFacingHalfCircle("U+E572", null, "Left-facing half circle"),

  /// Left-facing hook.
  ornamentLeftFacingHook("U+E574", null, "Left-facing hook"),

  /// Ornament left +.
  ornamentLeftPlus("U+E597", null, "Ornament left +"),

  /// Ornament left shake t.
  ornamentLeftShakeT("U+E596", null, "Ornament left shake t"),

  /// Ornament left vertical stroke.
  ornamentLeftVerticalStroke(
      "U+E594", "U+1D19B", "Ornament left vertical stroke"),

  /// Ornament left vertical stroke with cross (+).
  ornamentLeftVerticalStrokeWithCross(
      "U+E595", null, "Ornament left vertical stroke with cross (+)"),

  /// Ornament low left concave stroke.
  ornamentLowLeftConcaveStroke(
      "U+E598", null, "Ornament low left concave stroke"),

  /// Ornament low left convex stroke.
  ornamentLowLeftConvexStroke(
      "U+E599", "U+1D1A4", "Ornament low left convex stroke"),

  /// Ornament low right concave stroke.
  ornamentLowRightConcaveStroke(
      "U+E5A5", "U+1D1A3", "Ornament low right concave stroke"),

  /// Ornament low right convex stroke.
  ornamentLowRightConvexStroke(
      "U+E5A6", null, "Ornament low right convex stroke"),

  /// Ornament middle vertical stroke.
  ornamentMiddleVerticalStroke(
      "U+E59F", "U+1D1A0", "Ornament middle vertical stroke"),

  /// Mordent.
  ornamentMordent("U+E56D", null, "Mordent"),

  /// Oblique straight line NW-SE.
  ornamentObliqueLineAfterNote("U+E57C", null, "Oblique straight line NW-SE"),

  /// Oblique straight line SW-NE.
  ornamentObliqueLineBeforeNote("U+E57B", null, "Oblique straight line SW-NE"),

  /// Oblique straight line tilted NW-SE.
  ornamentObliqueLineHorizAfterNote(
      "U+E580", null, "Oblique straight line tilted NW-SE"),

  /// Oblique straight line tilted SW-NE.
  ornamentObliqueLineHorizBeforeNote(
      "U+E57F", null, "Oblique straight line tilted SW-NE"),

  /// Oriscus.
  ornamentOriscus("U+EA21", null, "Oriscus"),

  /// Pincé (Couperin).
  ornamentPinceCouperin("U+E588", null, "Pincé (Couperin)"),

  /// Port de voix.
  ornamentPortDeVoixV("U+E570", null, "Port de voix"),

  /// Supported appoggiatura trill.
  ornamentPrecompAppoggTrill("U+E5B2", null, "Supported appoggiatura trill"),

  /// Supported appoggiatura trill with two-note suffix.
  ornamentPrecompAppoggTrillSuffix(
      "U+E5B3", null, "Supported appoggiatura trill with two-note suffix"),

  /// Cadence.
  ornamentPrecompCadence("U+E5BE", null, "Cadence"),

  /// Cadence with upper prefix.
  ornamentPrecompCadenceUpperPrefix(
      "U+E5C1", null, "Cadence with upper prefix"),

  /// Cadence with upper prefix and turn.
  ornamentPrecompCadenceUpperPrefixTurn(
      "U+E5C2", null, "Cadence with upper prefix and turn"),

  /// Cadence with turn.
  ornamentPrecompCadenceWithTurn("U+E5BF", null, "Cadence with turn"),

  /// Descending slide.
  ornamentPrecompDescendingSlide("U+E5B1", null, "Descending slide"),

  /// Double cadence with lower prefix.
  ornamentPrecompDoubleCadenceLowerPrefix(
      "U+E5C0", null, "Double cadence with lower prefix"),

  /// Double cadence with upper prefix.
  ornamentPrecompDoubleCadenceUpperPrefix(
      "U+E5C3", null, "Double cadence with upper prefix"),

  /// Double cadence with upper prefix and turn.
  ornamentPrecompDoubleCadenceUpperPrefixTurn(
      "U+E5C4", null, "Double cadence with upper prefix and turn"),

  /// Inverted mordent with upper prefix.
  ornamentPrecompInvertedMordentUpperPrefix(
      "U+E5C7", null, "Inverted mordent with upper prefix"),

  /// Mordent with release.
  ornamentPrecompMordentRelease("U+E5C5", null, "Mordent with release"),

  /// Mordent with upper prefix.
  ornamentPrecompMordentUpperPrefix(
      "U+E5C6", null, "Mordent with upper prefix"),

  /// Pre-beat port de voix followed by multiple mordent (Dandrieu).
  ornamentPrecompPortDeVoixMordent("U+E5BC", null,
      "Pre-beat port de voix followed by multiple mordent (Dandrieu)"),

  /// Slide.
  ornamentPrecompSlide("U+E5B0", null, "Slide"),

  /// Slide-trill with two-note suffix (J.S. Bach).
  ornamentPrecompSlideTrillBach(
      "U+E5B8", null, "Slide-trill with two-note suffix (J.S. Bach)"),

  /// Slide-trill (D'Anglebert).
  ornamentPrecompSlideTrillDAnglebert(
      "U+E5B5", null, "Slide-trill (D'Anglebert)"),

  /// Slide-trill with one-note suffix (Marpurg).
  ornamentPrecompSlideTrillMarpurg(
      "U+E5B6", null, "Slide-trill with one-note suffix (Marpurg)"),

  /// Slide-trill (Muffat).
  ornamentPrecompSlideTrillMuffat("U+E5B9", null, "Slide-trill (Muffat)"),

  /// Slide-trill with two-note suffix (Muffat).
  ornamentPrecompSlideTrillSuffixMuffat(
      "U+E5BA", null, "Slide-trill with two-note suffix (Muffat)"),

  /// Trill with lower suffix.
  ornamentPrecompTrillLowerSuffix("U+E5C8", null, "Trill with lower suffix"),

  /// Trill with two-note suffix (Dandrieu).
  ornamentPrecompTrillSuffixDandrieu(
      "U+E5BB", null, "Trill with two-note suffix (Dandrieu)"),

  /// Trill with mordent.
  ornamentPrecompTrillWithMordent("U+E5BD", null, "Trill with mordent"),

  /// Turn-trill with two-note suffix (J.S. Bach).
  ornamentPrecompTurnTrillBach(
      "U+E5B7", null, "Turn-trill with two-note suffix (J.S. Bach)"),

  /// Turn-trill (D'Anglebert).
  ornamentPrecompTurnTrillDAnglebert(
      "U+E5B4", null, "Turn-trill (D'Anglebert)"),

  /// Quilisma.
  ornamentQuilisma("U+EA20", null, "Quilisma"),

  /// Right-facing half circle.
  ornamentRightFacingHalfCircle("U+E571", null, "Right-facing half circle"),

  /// Right-facing hook.
  ornamentRightFacingHook("U+E573", null, "Right-facing hook"),

  /// Ornament right vertical stroke.
  ornamentRightVerticalStroke("U+E5A4", null, "Ornament right vertical stroke"),

  /// Schleifer (long mordent).
  ornamentSchleifer("U+E587", null, "Schleifer (long mordent)"),

  /// Shake.
  ornamentShake3("U+E582", null, "Shake"),

  /// Shake (Muffat).
  ornamentShakeMuffat1("U+E584", null, "Shake (Muffat)"),

  /// Short oblique straight line NW-SE.
  ornamentShortObliqueLineAfterNote(
      "U+E57A", null, "Short oblique straight line NW-SE"),

  /// Short oblique straight line SW-NE.
  ornamentShortObliqueLineBeforeNote(
      "U+E579", null, "Short oblique straight line SW-NE"),

  /// Short trill.
  ornamentShortTrill("U+E56C", null, "Short trill"),

  /// Ornament top left concave stroke.
  ornamentTopLeftConcaveStroke(
      "U+E590", null, "Ornament top left concave stroke"),

  /// Ornament top left convex stroke.
  ornamentTopLeftConvexStroke(
      "U+E591", "U+1D1A5", "Ornament top left convex stroke"),

  /// Ornament top right concave stroke.
  ornamentTopRightConcaveStroke(
      "U+E5A0", null, "Ornament top right concave stroke"),

  /// Ornament top right convex stroke.
  ornamentTopRightConvexStroke(
      "U+E5A1", "U+1D19E", "Ornament top right convex stroke"),

  /// Tremblement.
  ornamentTremblement("U+E56E", null, "Tremblement"),

  /// Tremblement appuyé (Couperin).
  ornamentTremblementCouperin("U+E589", null, "Tremblement appuyé (Couperin)"),

  /// Trill.
  ornamentTrill("U+E566", "U+1D196", "Trill"),

  /// Turn.
  ornamentTurn("U+E567", "U+1D197", "Turn"),

  /// Inverted turn.
  ornamentTurnInverted("U+E568", "U+1D198", "Inverted turn"),

  /// Turn with slash.
  ornamentTurnSlash("U+E569", "U+1D199", "Turn with slash"),

  /// Turn up.
  ornamentTurnUp("U+E56A", "U+1D19A", "Turn up"),

  /// Inverted turn up.
  ornamentTurnUpS("U+E56B", null, "Inverted turn up"),

  /// Curve above.
  ornamentUpCurve("U+E577", null, "Curve above"),

  /// Vertical line.
  ornamentVerticalLine("U+E583", null, "Vertical line"),

  /// Ornament zig-zag line without right-hand end.
  ornamentZigZagLineNoRightEnd(
      "U+E59D", "U+1D19C", "Ornament zig-zag line without right-hand end"),

  /// Ornament zig-zag line with right-hand end.
  ornamentZigZagLineWithRightEnd(
      "U+E59E", "U+1D19D", "Ornament zig-zag line with right-hand end"),

  /// Ottava.
  ottava("U+E510", null, "Ottava"),

  /// Ottava alta.
  ottavaAlta("U+E511", "U+1D136", "Ottava alta"),

  /// Ottava bassa.
  ottavaBassa("U+E512", "U+1D137", "Ottava bassa"),

  /// Ottava bassa (ba).
  ottavaBassaBa("U+E513", null, "Ottava bassa (ba)"),

  /// Ottava bassa (8vb).
  ottavaBassaVb("U+E51C", null, "Ottava bassa (8vb)"),

  /// Penderecki unmeasured tremolo.
  pendereckiTremolo("U+E22B", null, "Penderecki unmeasured tremolo"),

  /// Agogo.
  pictAgogo("U+E717", null, "Agogo"),

  /// Almglocken.
  pictAlmglocken("U+E712", null, "Almglocken"),

  /// Anvil.
  pictAnvil("U+E701", null, "Anvil"),

  /// Bamboo tube chimes.
  pictBambooChimes("U+E6C3", null, "Bamboo tube chimes"),

  /// Bamboo scraper.
  pictBambooScraper("U+E6FB", null, "Bamboo scraper"),

  /// Bass drum.
  pictBassDrum("U+E6D4", null, "Bass drum"),

  /// Bass drum on side.
  pictBassDrumOnSide("U+E6D5", null, "Bass drum on side"),

  /// Bow.
  pictBeaterBow("U+E7DE", null, "Bow"),

  /// Box for percussion beater.
  pictBeaterBox("U+E7EB", null, "Box for percussion beater"),

  /// Brass mallets down.
  pictBeaterBrassMalletsDown("U+E7DA", null, "Brass mallets down"),

  /// Brass mallets left.
  pictBeaterBrassMalletsLeft("U+E7EE", null, "Brass mallets left"),

  /// Brass mallets right.
  pictBeaterBrassMalletsRight("U+E7ED", null, "Brass mallets right"),

  /// Brass mallets up.
  pictBeaterBrassMalletsUp("U+E7D9", null, "Brass mallets up"),

  /// Combining dashed circle for round beaters (plated).
  pictBeaterCombiningDashedCircle(
      "U+E7EA", null, "Combining dashed circle for round beaters (plated)"),

  /// Combining parentheses for round beaters (padded).
  pictBeaterCombiningParentheses(
      "U+E7E9", null, "Combining parentheses for round beaters (padded)"),

  /// Double bass drum stick down.
  pictBeaterDoubleBassDrumDown("U+E7A1", null, "Double bass drum stick down"),

  /// Double bass drum stick up.
  pictBeaterDoubleBassDrumUp("U+E7A0", null, "Double bass drum stick up"),

  /// Finger.
  pictBeaterFinger("U+E7E4", null, "Finger"),

  /// Fingernails.
  pictBeaterFingernails("U+E7E6", null, "Fingernails"),

  /// Fist.
  pictBeaterFist("U+E7E5", null, "Fist"),

  /// Guiro scraper.
  pictBeaterGuiroScraper("U+E7DD", null, "Guiro scraper"),

  /// Hammer.
  pictBeaterHammer("U+E7E1", null, "Hammer"),

  /// Metal hammer, down.
  pictBeaterHammerMetalDown("U+E7D0", null, "Metal hammer, down"),

  /// Metal hammer, up.
  pictBeaterHammerMetalUp("U+E7CF", null, "Metal hammer, up"),

  /// Plastic hammer, down.
  pictBeaterHammerPlasticDown("U+E7CE", null, "Plastic hammer, down"),

  /// Plastic hammer, up.
  pictBeaterHammerPlasticUp("U+E7CD", null, "Plastic hammer, up"),

  /// Wooden hammer, down.
  pictBeaterHammerWoodDown("U+E7CC", null, "Wooden hammer, down"),

  /// Wooden hammer, up.
  pictBeaterHammerWoodUp("U+E7CB", null, "Wooden hammer, up"),

  /// Hand.
  pictBeaterHand("U+E7E3", null, "Hand"),

  /// Hard bass drum stick down.
  pictBeaterHardBassDrumDown("U+E79D", null, "Hard bass drum stick down"),

  /// Hard bass drum stick up.
  pictBeaterHardBassDrumUp("U+E79C", null, "Hard bass drum stick up"),

  /// Hard glockenspiel stick down.
  pictBeaterHardGlockenspielDown(
      "U+E785", null, "Hard glockenspiel stick down"),

  /// Hard glockenspiel stick left.
  pictBeaterHardGlockenspielLeft(
      "U+E787", null, "Hard glockenspiel stick left"),

  /// Hard glockenspiel stick right.
  pictBeaterHardGlockenspielRight(
      "U+E786", null, "Hard glockenspiel stick right"),

  /// Hard glockenspiel stick up.
  pictBeaterHardGlockenspielUp("U+E784", null, "Hard glockenspiel stick up"),

  /// Hard timpani stick down.
  pictBeaterHardTimpaniDown("U+E791", null, "Hard timpani stick down"),

  /// Hard timpani stick left.
  pictBeaterHardTimpaniLeft("U+E793", null, "Hard timpani stick left"),

  /// Hard timpani stick right.
  pictBeaterHardTimpaniRight("U+E792", null, "Hard timpani stick right"),

  /// Hard timpani stick up.
  pictBeaterHardTimpaniUp("U+E790", null, "Hard timpani stick up"),

  /// Hard xylophone stick down.
  pictBeaterHardXylophoneDown("U+E779", null, "Hard xylophone stick down"),

  /// Hard xylophone stick left.
  pictBeaterHardXylophoneLeft("U+E77B", null, "Hard xylophone stick left"),

  /// Hard xylophone stick right.
  pictBeaterHardXylophoneRight("U+E77A", null, "Hard xylophone stick right"),

  /// Hard xylophone stick up.
  pictBeaterHardXylophoneUp("U+E778", null, "Hard xylophone stick up"),

  /// Hard yarn beater down.
  pictBeaterHardYarnDown("U+E7AB", null, "Hard yarn beater down"),

  /// Hard yarn beater left.
  pictBeaterHardYarnLeft("U+E7AD", null, "Hard yarn beater left"),

  /// Hard yarn beater right.
  pictBeaterHardYarnRight("U+E7AC", null, "Hard yarn beater right"),

  /// Hard yarn beater up.
  pictBeaterHardYarnUp("U+E7AA", null, "Hard yarn beater up"),

  /// Jazz sticks down.
  pictBeaterJazzSticksDown("U+E7D4", null, "Jazz sticks down"),

  /// Jazz sticks up.
  pictBeaterJazzSticksUp("U+E7D3", null, "Jazz sticks up"),

  /// Knitting needle.
  pictBeaterKnittingNeedle("U+E7E2", null, "Knitting needle"),

  /// Chime hammer up.
  pictBeaterMallet("U+E7DF", null, "Chime hammer up"),

  /// Chime hammer down.
  pictBeaterMalletDown("U+E7EC", null, "Chime hammer down"),

  /// Medium bass drum stick down.
  pictBeaterMediumBassDrumDown("U+E79B", null, "Medium bass drum stick down"),

  /// Medium bass drum stick up.
  pictBeaterMediumBassDrumUp("U+E79A", null, "Medium bass drum stick up"),

  /// Medium timpani stick down.
  pictBeaterMediumTimpaniDown("U+E78D", null, "Medium timpani stick down"),

  /// Medium timpani stick left.
  pictBeaterMediumTimpaniLeft("U+E78F", null, "Medium timpani stick left"),

  /// Medium timpani stick right.
  pictBeaterMediumTimpaniRight("U+E78E", null, "Medium timpani stick right"),

  /// Medium timpani stick up.
  pictBeaterMediumTimpaniUp("U+E78C", null, "Medium timpani stick up"),

  /// Medium xylophone stick down.
  pictBeaterMediumXylophoneDown("U+E775", null, "Medium xylophone stick down"),

  /// Medium xylophone stick left.
  pictBeaterMediumXylophoneLeft("U+E777", null, "Medium xylophone stick left"),

  /// Medium xylophone stick right.
  pictBeaterMediumXylophoneRight(
      "U+E776", null, "Medium xylophone stick right"),

  /// Medium xylophone stick up.
  pictBeaterMediumXylophoneUp("U+E774", null, "Medium xylophone stick up"),

  /// Medium yarn beater down.
  pictBeaterMediumYarnDown("U+E7A7", null, "Medium yarn beater down"),

  /// Medium yarn beater left.
  pictBeaterMediumYarnLeft("U+E7A9", null, "Medium yarn beater left"),

  /// Medium yarn beater right.
  pictBeaterMediumYarnRight("U+E7A8", null, "Medium yarn beater right"),

  /// Medium yarn beater up.
  pictBeaterMediumYarnUp("U+E7A6", null, "Medium yarn beater up"),

  /// Metal bass drum stick down.
  pictBeaterMetalBassDrumDown("U+E79F", null, "Metal bass drum stick down"),

  /// Metal bass drum stick up.
  pictBeaterMetalBassDrumUp("U+E79E", null, "Metal bass drum stick up"),

  /// Metal beater down.
  pictBeaterMetalDown("U+E7C8", null, "Metal beater down"),

  /// Metal hammer.
  pictBeaterMetalHammer("U+E7E0", null, "Metal hammer"),

  /// Metal beater, left.
  pictBeaterMetalLeft("U+E7CA", null, "Metal beater, left"),

  /// Metal beater, right.
  pictBeaterMetalRight("U+E7C9", null, "Metal beater, right"),

  /// Metal beater, up.
  pictBeaterMetalUp("U+E7C7", null, "Metal beater, up"),

  /// Snare sticks down.
  pictBeaterSnareSticksDown("U+E7D2", null, "Snare sticks down"),

  /// Snare sticks up.
  pictBeaterSnareSticksUp("U+E7D1", null, "Snare sticks up"),

  /// Soft bass drum stick down.
  pictBeaterSoftBassDrumDown("U+E799", null, "Soft bass drum stick down"),

  /// Soft bass drum stick up.
  pictBeaterSoftBassDrumUp("U+E798", null, "Soft bass drum stick up"),

  /// Soft glockenspiel stick down.
  pictBeaterSoftGlockenspielDown(
      "U+E781", null, "Soft glockenspiel stick down"),

  /// Soft glockenspiel stick left.
  pictBeaterSoftGlockenspielLeft(
      "U+E783", null, "Soft glockenspiel stick left"),

  /// Soft glockenspiel stick right.
  pictBeaterSoftGlockenspielRight(
      "U+E782", null, "Soft glockenspiel stick right"),

  /// Soft glockenspiel stick up.
  pictBeaterSoftGlockenspielUp("U+E780", null, "Soft glockenspiel stick up"),

  /// Soft timpani stick down.
  pictBeaterSoftTimpaniDown("U+E789", null, "Soft timpani stick down"),

  /// Soft timpani stick left.
  pictBeaterSoftTimpaniLeft("U+E78B", null, "Soft timpani stick left"),

  /// Soft timpani stick right.
  pictBeaterSoftTimpaniRight("U+E78A", null, "Soft timpani stick right"),

  /// Soft timpani stick up.
  pictBeaterSoftTimpaniUp("U+E788", null, "Soft timpani stick up"),

  /// Soft xylophone beaters.
  pictBeaterSoftXylophone("U+E7DB", null, "Soft xylophone beaters"),

  /// Soft xylophone stick down.
  pictBeaterSoftXylophoneDown("U+E771", null, "Soft xylophone stick down"),

  /// Soft xylophone stick left.
  pictBeaterSoftXylophoneLeft("U+E773", null, "Soft xylophone stick left"),

  /// Soft xylophone stick right.
  pictBeaterSoftXylophoneRight("U+E772", null, "Soft xylophone stick right"),

  /// Soft xylophone stick up.
  pictBeaterSoftXylophoneUp("U+E770", null, "Soft xylophone stick up"),

  /// Soft yarn beater down.
  pictBeaterSoftYarnDown("U+E7A3", null, "Soft yarn beater down"),

  /// Soft yarn beater left.
  pictBeaterSoftYarnLeft("U+E7A5", null, "Soft yarn beater left"),

  /// Soft yarn beater right.
  pictBeaterSoftYarnRight("U+E7A4", null, "Soft yarn beater right"),

  /// Soft yarn beater up.
  pictBeaterSoftYarnUp("U+E7A2", null, "Soft yarn beater up"),

  /// Spoon-shaped wooden mallet.
  pictBeaterSpoonWoodenMallet("U+E7DC", null, "Spoon-shaped wooden mallet"),

  /// Superball beater down.
  pictBeaterSuperballDown("U+E7AF", null, "Superball beater down"),

  /// Superball beater left.
  pictBeaterSuperballLeft("U+E7B1", null, "Superball beater left"),

  /// Superball beater right.
  pictBeaterSuperballRight("U+E7B0", null, "Superball beater right"),

  /// Superball beater up.
  pictBeaterSuperballUp("U+E7AE", null, "Superball beater up"),

  /// Triangle beater down.
  pictBeaterTriangleDown("U+E7D6", null, "Triangle beater down"),

  /// Triangle beater plain.
  pictBeaterTrianglePlain("U+E7EF", null, "Triangle beater plain"),

  /// Triangle beater up.
  pictBeaterTriangleUp("U+E7D5", null, "Triangle beater up"),

  /// Wire brushes down.
  pictBeaterWireBrushesDown("U+E7D8", null, "Wire brushes down"),

  /// Wire brushes up.
  pictBeaterWireBrushesUp("U+E7D7", null, "Wire brushes up"),

  /// Wood timpani stick down.
  pictBeaterWoodTimpaniDown("U+E795", null, "Wood timpani stick down"),

  /// Wood timpani stick left.
  pictBeaterWoodTimpaniLeft("U+E797", null, "Wood timpani stick left"),

  /// Wood timpani stick right.
  pictBeaterWoodTimpaniRight("U+E796", null, "Wood timpani stick right"),

  /// Wood timpani stick up.
  pictBeaterWoodTimpaniUp("U+E794", null, "Wood timpani stick up"),

  /// Wood xylophone stick down.
  pictBeaterWoodXylophoneDown("U+E77D", null, "Wood xylophone stick down"),

  /// Wood xylophone stick left.
  pictBeaterWoodXylophoneLeft("U+E77F", null, "Wood xylophone stick left"),

  /// Wood xylophone stick right.
  pictBeaterWoodXylophoneRight("U+E77E", null, "Wood xylophone stick right"),

  /// Wood xylophone stick up.
  pictBeaterWoodXylophoneUp("U+E77C", null, "Wood xylophone stick up"),

  /// Bell.
  pictBell("U+E714", null, "Bell"),

  /// Bell of cymbal.
  pictBellOfCymbal("U+E72A", null, "Bell of cymbal"),

  /// Bell plate.
  pictBellPlate("U+E713", null, "Bell plate"),

  /// Bell tree.
  pictBellTree("U+E71A", null, "Bell tree"),

  /// Bird whistle.
  pictBirdWhistle("U+E751", null, "Bird whistle"),

  /// Board clapper.
  pictBoardClapper("U+E6F7", null, "Board clapper"),

  /// Bongos.
  pictBongos("U+E6DD", null, "Bongos"),

  /// Brake drum.
  pictBrakeDrum("U+E6E1", null, "Brake drum"),

  /// Cabasa.
  pictCabasa("U+E743", null, "Cabasa"),

  /// Cannon.
  pictCannon("U+E761", null, "Cannon"),

  /// Car horn.
  pictCarHorn("U+E755", null, "Car horn"),

  /// Castanets.
  pictCastanets("U+E6F8", null, "Castanets"),

  /// Castanets with handle.
  pictCastanetsWithHandle("U+E6F9", null, "Castanets with handle"),

  /// Celesta.
  pictCelesta("U+E6B0", null, "Celesta"),

  /// Cencerro.
  pictCencerro("U+E716", null, "Cencerro"),

  /// Center (Weinberg).
  pictCenter1("U+E7FE", null, "Center (Weinberg)"),

  /// Center (Ghent).
  pictCenter2("U+E7FF", null, "Center (Ghent)"),

  /// Center (Caltabiano).
  pictCenter3("U+E800", null, "Center (Caltabiano)"),

  /// Chain rattle.
  pictChainRattle("U+E748", null, "Chain rattle"),

  /// Chimes.
  pictChimes("U+E6C2", null, "Chimes"),

  /// Chinese cymbal.
  pictChineseCymbal("U+E726", null, "Chinese cymbal"),

  /// Choke (Weinberg).
  pictChokeCymbal("U+E805", null, "Choke (Weinberg)"),

  /// Claves.
  pictClaves("U+E6F2", null, "Claves"),

  /// Coins.
  pictCoins("U+E7E7", null, "Coins"),

  /// Conga.
  pictConga("U+E6DE", null, "Conga"),

  /// Cow bell.
  pictCowBell("U+E711", null, "Cow bell"),

  /// Crash cymbals.
  pictCrashCymbals("U+E720", null, "Crash cymbals"),

  /// Crotales.
  pictCrotales("U+E6AE", null, "Crotales"),

  /// Combining crush for stem.
  pictCrushStem("U+E80C", null, "Combining crush for stem"),

  /// Cuica.
  pictCuica("U+E6E4", null, "Cuica"),

  /// Cymbal tongs.
  pictCymbalTongs("U+E728", null, "Cymbal tongs"),

  /// Damp.
  pictDamp1("U+E7F9", null, "Damp"),

  /// Damp 2.
  pictDamp2("U+E7FA", null, "Damp 2"),

  /// Damp 3.
  pictDamp3("U+E7FB", null, "Damp 3"),

  /// Damp 4.
  pictDamp4("U+E7FC", null, "Damp 4"),

  /// Combining X for stem (dead note).
  pictDeadNoteStem("U+E80D", null, "Combining X for stem (dead note)"),

  /// Drum stick.
  pictDrumStick("U+E7E8", null, "Drum stick"),

  /// Duck call.
  pictDuckCall("U+E757", null, "Duck call"),

  /// Edge of cymbal.
  pictEdgeOfCymbal("U+E729", null, "Edge of cymbal"),

  /// Empty trapezoid.
  pictEmptyTrap("U+E6A9", null, "Empty trapezoid"),

  /// Finger cymbals.
  pictFingerCymbals("U+E727", null, "Finger cymbals"),

  /// Flexatone.
  pictFlexatone("U+E740", null, "Flexatone"),

  /// Football rattle.
  pictFootballRatchet("U+E6F5", null, "Football rattle"),

  /// Glass harmonica.
  pictGlassHarmonica("U+E765", null, "Glass harmonica"),

  /// Glass harp.
  pictGlassHarp("U+E764", null, "Glass harp"),

  /// Glass plate chimes.
  pictGlassPlateChimes("U+E6C6", null, "Glass plate chimes"),

  /// Glass tube chimes.
  pictGlassTubeChimes("U+E6C5", null, "Glass tube chimes"),

  /// Glockenspiel.
  pictGlsp("U+E6A0", null, "Glockenspiel"),

  /// Glockenspiel (Smith Brindle).
  pictGlspSmithBrindle("U+E6AA", null, "Glockenspiel (Smith Brindle)"),

  /// Goblet drum (djembe, dumbek).
  pictGobletDrum("U+E6E2", null, "Goblet drum (djembe, dumbek)"),

  /// Gong.
  pictGong("U+E732", null, "Gong"),

  /// Gong with button (nipple).
  pictGongWithButton("U+E733", null, "Gong with button (nipple)"),

  /// Guiro.
  pictGuiro("U+E6F3", null, "Guiro"),

  /// Hard gum beater, down.
  pictGumHardDown("U+E7C4", null, "Hard gum beater, down"),

  /// Hard gum beater, left.
  pictGumHardLeft("U+E7C6", null, "Hard gum beater, left"),

  /// Hard gum beater, right.
  pictGumHardRight("U+E7C5", null, "Hard gum beater, right"),

  /// Hard gum beater, up.
  pictGumHardUp("U+E7C3", null, "Hard gum beater, up"),

  /// Medium gum beater, down.
  pictGumMediumDown("U+E7C0", null, "Medium gum beater, down"),

  /// Medium gum beater, left.
  pictGumMediumLeft("U+E7C2", null, "Medium gum beater, left"),

  /// Medium gum beater, right.
  pictGumMediumRight("U+E7C1", null, "Medium gum beater, right"),

  /// Medium gum beater, up.
  pictGumMediumUp("U+E7BF", null, "Medium gum beater, up"),

  /// Soft gum beater, down.
  pictGumSoftDown("U+E7BC", null, "Soft gum beater, down"),

  /// Soft gum beater, left.
  pictGumSoftLeft("U+E7BE", null, "Soft gum beater, left"),

  /// Soft gum beater, right.
  pictGumSoftRight("U+E7BD", null, "Soft gum beater, right"),

  /// Soft gum beater, up.
  pictGumSoftUp("U+E7BB", null, "Soft gum beater, up"),

  /// Half-open.
  pictHalfOpen1("U+E7F6", null, "Half-open"),

  /// Half-open 2 (Weinberg).
  pictHalfOpen2("U+E7F7", null, "Half-open 2 (Weinberg)"),

  /// Handbell.
  pictHandbell("U+E715", null, "Handbell"),

  /// Hi-hat.
  pictHiHat("U+E722", null, "Hi-hat"),

  /// Hi-hat cymbals on stand.
  pictHiHatOnStand("U+E723", null, "Hi-hat cymbals on stand"),

  /// Jaw harp.
  pictJawHarp("U+E767", null, "Jaw harp"),

  /// Jingle bells.
  pictJingleBells("U+E719", null, "Jingle bells"),

  /// Klaxon horn.
  pictKlaxonHorn("U+E756", null, "Klaxon horn"),

  /// Right hand (Agostini).
  pictLeftHandCircle("U+E807", null, "Right hand (Agostini)"),

  /// Lion's roar.
  pictLionsRoar("U+E763", null, "Lion's roar"),

  /// Lithophone.
  pictLithophone("U+E6B1", null, "Lithophone"),

  /// Log drum.
  pictLogDrum("U+E6DF", null, "Log drum"),

  /// Lotus flute.
  pictLotusFlute("U+E75A", null, "Lotus flute"),

  /// Marimba.
  pictMar("U+E6A6", null, "Marimba"),

  /// Marimba (Smith Brindle).
  pictMarSmithBrindle("U+E6AC", null, "Marimba (Smith Brindle)"),

  /// Maraca.
  pictMaraca("U+E741", null, "Maraca"),

  /// Maracas.
  pictMaracas("U+E742", null, "Maracas"),

  /// Megaphone.
  pictMegaphone("U+E759", null, "Megaphone"),

  /// Metal plate chimes.
  pictMetalPlateChimes("U+E6C8", null, "Metal plate chimes"),

  /// Metal tube chimes.
  pictMetalTubeChimes("U+E6C7", null, "Metal tube chimes"),

  /// Musical saw.
  pictMusicalSaw("U+E766", null, "Musical saw"),

  /// Normal position (Caltabiano).
  pictNormalPosition("U+E804", null, "Normal position (Caltabiano)"),

  /// On rim.
  pictOnRim("U+E7F4", null, "On rim"),

  /// Open.
  pictOpen("U+E7F8", null, "Open"),

  /// Closed / rim shot.
  pictOpenRimShot("U+E7F5", null, "Closed / rim shot"),

  /// Pistol shot.
  pictPistolShot("U+E760", null, "Pistol shot"),

  /// Police whistle.
  pictPoliceWhistle("U+E752", null, "Police whistle"),

  /// Quijada (jawbone).
  pictQuijada("U+E6FA", null, "Quijada (jawbone)"),

  /// Rainstick.
  pictRainstick("U+E747", null, "Rainstick"),

  /// Ratchet.
  pictRatchet("U+E6F4", null, "Ratchet"),

  /// Reco-reco.
  pictRecoReco("U+E6FC", null, "Reco-reco"),

  /// Left hand (Agostini).
  pictRightHandSquare("U+E806", null, "Left hand (Agostini)"),

  /// Rim or edge (Weinberg).
  pictRim1("U+E801", null, "Rim or edge (Weinberg)"),

  /// Rim (Ghent).
  pictRim2("U+E802", null, "Rim (Ghent)"),

  /// Rim (Caltabiano).
  pictRim3("U+E803", null, "Rim (Caltabiano)"),

  /// Rim shot for stem.
  pictRimShotOnStem("U+E7FD", null, "Rim shot for stem"),

  /// Sandpaper blocks.
  pictSandpaperBlocks("U+E762", null, "Sandpaper blocks"),

  /// Scrape around rim (counter-clockwise).
  pictScrapeAroundRim("U+E7F3", null, "Scrape around rim (counter-clockwise)"),

  /// Scrape around rim (clockwise).
  pictScrapeAroundRimClockwise("U+E80E", null, "Scrape around rim (clockwise)"),

  /// Scrape from center to edge.
  pictScrapeCenterToEdge("U+E7F1", null, "Scrape from center to edge"),

  /// Scrape from edge to center.
  pictScrapeEdgeToCenter("U+E7F2", null, "Scrape from edge to center"),

  /// Shell bells.
  pictShellBells("U+E718", null, "Shell bells"),

  /// Shell chimes.
  pictShellChimes("U+E6C4", null, "Shell chimes"),

  /// Siren.
  pictSiren("U+E753", null, "Siren"),

  /// Sistrum.
  pictSistrum("U+E746", null, "Sistrum"),

  /// Sizzle cymbal.
  pictSizzleCymbal("U+E724", null, "Sizzle cymbal"),

  /// Sleigh bell.
  pictSleighBell("U+E710", null, "Sleigh bell"),

  /// Slide brush on gong.
  pictSlideBrushOnGong("U+E734", null, "Slide brush on gong"),

  /// Slide whistle.
  pictSlideWhistle("U+E750", null, "Slide whistle"),

  /// Slit drum.
  pictSlitDrum("U+E6E0", null, "Slit drum"),

  /// Snare drum.
  pictSnareDrum("U+E6D1", null, "Snare drum"),

  /// Military snare drum.
  pictSnareDrumMilitary("U+E6D3", null, "Military snare drum"),

  /// Snare drum, snares off.
  pictSnareDrumSnaresOff("U+E6D2", null, "Snare drum, snares off"),

  /// Steel drums.
  pictSteelDrums("U+E6AF", null, "Steel drums"),

  /// Stick shot.
  pictStickShot("U+E7F0", null, "Stick shot"),

  /// Superball.
  pictSuperball("U+E7B2", null, "Superball"),

  /// Suspended cymbal.
  pictSuspendedCymbal("U+E721", null, "Suspended cymbal"),

  /// Combining swish for stem.
  pictSwishStem("U+E808", null, "Combining swish for stem"),

  /// Indian tabla.
  pictTabla("U+E6E3", null, "Indian tabla"),

  /// Tam-tam.
  pictTamTam("U+E730", null, "Tam-tam"),

  /// Tam-tam with beater (Smith Brindle).
  pictTamTamWithBeater("U+E731", null, "Tam-tam with beater (Smith Brindle)"),

  /// Tambourine.
  pictTambourine("U+E6DB", null, "Tambourine"),

  /// Temple blocks.
  pictTempleBlocks("U+E6F1", null, "Temple blocks"),

  /// Tenor drum.
  pictTenorDrum("U+E6D6", null, "Tenor drum"),

  /// Thundersheet.
  pictThundersheet("U+E744", null, "Thundersheet"),

  /// Timbales.
  pictTimbales("U+E6DC", null, "Timbales"),

  /// Timpani.
  pictTimpani("U+E6D0", null, "Timpani"),

  /// Tom-tom.
  pictTomTom("U+E6D7", null, "Tom-tom"),

  /// Chinese tom-tom.
  pictTomTomChinese("U+E6D8", null, "Chinese tom-tom"),

  /// Indo-American tom tom.
  pictTomTomIndoAmerican("U+E6DA", null, "Indo-American tom tom"),

  /// Japanese tom-tom.
  pictTomTomJapanese("U+E6D9", null, "Japanese tom-tom"),

  /// Triangle.
  pictTriangle("U+E700", null, "Triangle"),

  /// Tubaphone.
  pictTubaphone("U+E6B2", null, "Tubaphone"),

  /// Tubular bells.
  pictTubularBells("U+E6C0", null, "Tubular bells"),

  /// Combining turn left for stem.
  pictTurnLeftStem("U+E80A", null, "Combining turn left for stem"),

  /// Combining turn left or right for stem.
  pictTurnRightLeftStem(
      "U+E80B", null, "Combining turn left or right for stem"),

  /// Combining turn right for stem.
  pictTurnRightStem("U+E809", null, "Combining turn right for stem"),

  /// Vibraphone.
  pictVib("U+E6A7", null, "Vibraphone"),

  /// Metallophone (vibraphone motor off).
  pictVibMotorOff("U+E6A8", null, "Metallophone (vibraphone motor off)"),

  /// Vibraphone (Smith Brindle).
  pictVibSmithBrindle("U+E6AD", null, "Vibraphone (Smith Brindle)"),

  /// Vibraslap.
  pictVibraslap("U+E745", null, "Vibraslap"),

  /// Vietnamese hat cymbal.
  pictVietnameseHat("U+E725", null, "Vietnamese hat cymbal"),

  /// Whip.
  pictWhip("U+E6F6", null, "Whip"),

  /// Wind chimes (glass).
  pictWindChimesGlass("U+E6C1", null, "Wind chimes (glass)"),

  /// Wind machine.
  pictWindMachine("U+E754", null, "Wind machine"),

  /// Wind whistle (or mouth siren).
  pictWindWhistle("U+E758", null, "Wind whistle (or mouth siren)"),

  /// Wood block.
  pictWoodBlock("U+E6F0", null, "Wood block"),

  /// Wound beater, hard core down.
  pictWoundHardDown("U+E7B4", null, "Wound beater, hard core down"),

  /// Wound beater, hard core left.
  pictWoundHardLeft("U+E7B6", null, "Wound beater, hard core left"),

  /// Wound beater, hard core right.
  pictWoundHardRight("U+E7B5", null, "Wound beater, hard core right"),

  /// Wound beater, hard core up.
  pictWoundHardUp("U+E7B3", null, "Wound beater, hard core up"),

  /// Wound beater, soft core down.
  pictWoundSoftDown("U+E7B8", null, "Wound beater, soft core down"),

  /// Wound beater, soft core left.
  pictWoundSoftLeft("U+E7BA", null, "Wound beater, soft core left"),

  /// Wound beater, soft core right.
  pictWoundSoftRight("U+E7B9", null, "Wound beater, soft core right"),

  /// Wound beater, soft core up.
  pictWoundSoftUp("U+E7B7", null, "Wound beater, soft core up"),

  /// Xylophone.
  pictXyl("U+E6A1", null, "Xylophone"),

  /// Bass xylophone.
  pictXylBass("U+E6A3", null, "Bass xylophone"),

  /// Xylophone (Smith Brindle).
  pictXylSmithBrindle("U+E6AB", null, "Xylophone (Smith Brindle)"),

  /// Tenor xylophone.
  pictXylTenor("U+E6A2", null, "Tenor xylophone"),

  /// Trough tenor xylophone.
  pictXylTenorTrough("U+E6A5", null, "Trough tenor xylophone"),

  /// Trough xylophone.
  pictXylTrough("U+E6A4", null, "Trough xylophone"),

  /// Buzz pizzicato.
  pluckedBuzzPizzicato("U+E632", null, "Buzz pizzicato"),

  /// Damp.
  pluckedDamp("U+E638", "U+1D1B4", "Damp"),

  /// Damp all.
  pluckedDampAll("U+E639", "U+1D1B5", "Damp all"),

  /// Damp for stem.
  pluckedDampOnStem("U+E63B", null, "Damp for stem"),

  /// Fingernail flick.
  pluckedFingernailFlick("U+E637", null, "Fingernail flick"),

  /// Left-hand pizzicato.
  pluckedLeftHandPizzicato("U+E633", null, "Left-hand pizzicato"),

  /// Plectrum.
  pluckedPlectrum("U+E63A", null, "Plectrum"),

  /// Snap pizzicato above.
  pluckedSnapPizzicatoAbove("U+E631", null, "Snap pizzicato above"),

  /// Snap pizzicato below.
  pluckedSnapPizzicatoBelow("U+E630", "U+1D1AD", "Snap pizzicato below"),

  /// With fingernails.
  pluckedWithFingernails("U+E636", "U+1D1B3", "With fingernails"),

  /// Quindicesima.
  quindicesima("U+E514", null, "Quindicesima"),

  /// Quindicesima alta.
  quindicesimaAlta("U+E515", null, "Quindicesima alta"),

  /// Quindicesima bassa.
  quindicesimaBassa("U+E516", "U+1D139", "Quindicesima bassa"),

  /// Quindicesima bassa (mb).
  quindicesimaBassaMb("U+E51D", null, "Quindicesima bassa (mb)"),

  /// Repeat last bar.
  repeat1Bar("U+E500", "U+1D10E", "Repeat last bar"),

  /// Repeat last two bars.
  repeat2Bars("U+E501", "U+1D10F", "Repeat last two bars"),

  /// Repeat last four bars.
  repeat4Bars("U+E502", null, "Repeat last four bars"),

  /// Repeat bar lower dot.
  repeatBarLowerDot("U+E505", null, "Repeat bar lower dot"),

  /// Repeat bar slash.
  repeatBarSlash("U+E504", null, "Repeat bar slash"),

  /// Repeat bar upper dot.
  repeatBarUpperDot("U+E503", null, "Repeat bar upper dot"),

  /// Single repeat dot.
  repeatDot("U+E044", null, "Single repeat dot"),

  /// Repeat dots.
  repeatDots("U+E043", "U+1D108", "Repeat dots"),

  /// Left (start) repeat sign.
  repeatLeft("U+E040", "U+1D106", "Left (start) repeat sign"),

  /// Right (end) repeat sign.
  repeatRight("U+E041", "U+1D107", "Right (end) repeat sign"),

  /// Right and left repeat sign.
  repeatRightLeft("U+E042", null, "Right and left repeat sign"),

  /// 1024th rest.
  rest1024th("U+E4ED", null, "1024th rest"),

  /// 128th (semihemidemisemiquaver) rest.
  rest128th("U+E4EA", "U+1D142", "128th (semihemidemisemiquaver) rest"),

  /// 16th (semiquaver) rest.
  rest16th("U+E4E7", "U+1D13F", "16th (semiquaver) rest"),

  /// 256th rest.
  rest256th("U+E4EB", null, "256th rest"),

  /// 32nd (demisemiquaver) rest.
  rest32nd("U+E4E8", "U+1D140", "32nd (demisemiquaver) rest"),

  /// 512th rest.
  rest512th("U+E4EC", null, "512th rest"),

  /// 64th (hemidemisemiquaver) rest.
  rest64th("U+E4E9", "U+1D141", "64th (hemidemisemiquaver) rest"),

  /// Eighth (quaver) rest.
  rest8th("U+E4E6", "U+1D13E", "Eighth (quaver) rest"),

  /// Double whole (breve) rest.
  restDoubleWhole("U+E4E2", "U+1D13A", "Double whole (breve) rest"),

  /// Double whole rest on leger lines.
  restDoubleWholeLegerLine("U+E4F3", null, "Double whole rest on leger lines"),

  /// Multiple measure rest.
  restHBar("U+E4EE", "U+1D129", "Multiple measure rest"),

  /// H-bar, left half.
  restHBarLeft("U+E4EF", null, "H-bar, left half"),

  /// H-bar, middle.
  restHBarMiddle("U+E4F0", null, "H-bar, middle"),

  /// H-bar, right half.
  restHBarRight("U+E4F1", null, "H-bar, right half"),

  /// Half (minim) rest.
  restHalf("U+E4E4", "U+1D13C", "Half (minim) rest"),

  /// Half rest on leger line.
  restHalfLegerLine("U+E4F5", null, "Half rest on leger line"),

  /// Longa rest.
  restLonga("U+E4E1", null, "Longa rest"),

  /// Maxima rest.
  restMaxima("U+E4E0", null, "Maxima rest"),

  /// Quarter (crotchet) rest.
  restQuarter("U+E4E5", "U+1D13D", "Quarter (crotchet) rest"),

  /// Old-style quarter (crotchet) rest.
  restQuarterOld("U+E4F2", null, "Old-style quarter (crotchet) rest"),

  /// Z-style quarter (crotchet) rest.
  restQuarterZ("U+E4F6", null, "Z-style quarter (crotchet) rest"),

  /// Whole (semibreve) rest.
  restWhole("U+E4E3", "U+1D13B", "Whole (semibreve) rest"),

  /// Whole rest on leger line.
  restWholeLegerLine("U+E4F4", null, "Whole rest on leger line"),

  /// Reversed brace.
  reversedBrace("U+E001", null, "Reversed brace"),

  /// Reversed bracket bottom.
  reversedBracketBottom("U+E006", null, "Reversed bracket bottom"),

  /// Reversed bracket top.
  reversedBracketTop("U+E005", null, "Reversed bracket top"),

  /// Right repeat sign within bar.
  rightRepeatSmall("U+E04D", null, "Right repeat sign within bar"),

  /// Scale degree 1.
  scaleDegree1("U+EF00", null, "Scale degree 1"),

  /// Scale degree 2.
  scaleDegree2("U+EF01", null, "Scale degree 2"),

  /// Scale degree 3.
  scaleDegree3("U+EF02", null, "Scale degree 3"),

  /// Scale degree 4.
  scaleDegree4("U+EF03", null, "Scale degree 4"),

  /// Scale degree 5.
  scaleDegree5("U+EF04", null, "Scale degree 5"),

  /// Scale degree 6.
  scaleDegree6("U+EF05", null, "Scale degree 6"),

  /// Scale degree 7.
  scaleDegree7("U+EF06", null, "Scale degree 7"),

  /// Scale degree 8.
  scaleDegree8("U+EF07", null, "Scale degree 8"),

  /// Scale degree 9.
  scaleDegree9("U+EF08", null, "Scale degree 9"),

  /// Schäffer clef.
  schaefferClef("U+E06F", null, "Schäffer clef"),

  /// Schäffer F clef to G clef change.
  schaefferFClefToGClef("U+E072", null, "Schäffer F clef to G clef change"),

  /// Schäffer G clef to F clef change.
  schaefferGClefToFClef("U+E071", null, "Schäffer G clef to F clef change"),

  /// Schäffer previous clef.
  schaefferPreviousClef("U+E070", null, "Schäffer previous clef"),

  /// Segno.
  segno("U+E047", "U+1D10B", "Segno"),

  /// Segno (serpent).
  segnoSerpent1("U+E04A", null, "Segno (serpent)"),

  /// Segno (serpent with vertical lines).
  segnoSerpent2("U+E04B", null, "Segno (serpent with vertical lines)"),

  /// Semi-pitched percussion clef 1.
  semipitchedPercussionClef1("U+E06B", null, "Semi-pitched percussion clef 1"),

  /// Semi-pitched percussion clef 2.
  semipitchedPercussionClef2("U+E06C", null, "Semi-pitched percussion clef 2"),

  /// Flat.
  smnFlat("U+EC52", null, "Flat"),

  /// Flat (white).
  smnFlatWhite("U+EC53", null, "Flat (white)"),

  /// Double flat history sign.
  smnHistoryDoubleFlat("U+EC57", null, "Double flat history sign"),

  /// Double sharp history sign.
  smnHistoryDoubleSharp("U+EC55", null, "Double sharp history sign"),

  /// Flat history sign.
  smnHistoryFlat("U+EC56", null, "Flat history sign"),

  /// Sharp history sign.
  smnHistorySharp("U+EC54", null, "Sharp history sign"),

  /// Natural (N).
  smnNatural("U+EC58", null, "Natural (N)"),

  /// Sharp stem up.
  smnSharp("U+EC50", null, "Sharp stem up"),

  /// Sharp stem down.
  smnSharpDown("U+EC59", null, "Sharp stem down"),

  /// Sharp (white) stem up.
  smnSharpWhite("U+EC51", null, "Sharp (white) stem up"),

  /// Sharp (white) stem down.
  smnSharpWhiteDown("U+EC5A", null, "Sharp (white) stem down"),

  /// Split bar divider (bar spans a system break).
  splitBarDivider(
      "U+E00A", null, "Split bar divider (bar spans a system break)"),

  /// 1-line staff.
  staff1Line("U+E010", "U+1D116", "1-line staff"),

  /// 1-line staff (narrow).
  staff1LineNarrow("U+E01C", null, "1-line staff (narrow)"),

  /// 1-line staff (wide).
  staff1LineWide("U+E016", null, "1-line staff (wide)"),

  /// 2-line staff.
  staff2Lines("U+E011", "U+1D117", "2-line staff"),

  /// 2-line staff (narrow).
  staff2LinesNarrow("U+E01D", null, "2-line staff (narrow)"),

  /// 2-line staff (wide).
  staff2LinesWide("U+E017", null, "2-line staff (wide)"),

  /// 3-line staff.
  staff3Lines("U+E012", "U+1D118", "3-line staff"),

  /// 3-line staff (narrow).
  staff3LinesNarrow("U+E01E", null, "3-line staff (narrow)"),

  /// 3-line staff (wide).
  staff3LinesWide("U+E018", null, "3-line staff (wide)"),

  /// 4-line staff.
  staff4Lines("U+E013", "U+1D119", "4-line staff"),

  /// 4-line staff (narrow).
  staff4LinesNarrow("U+E01F", null, "4-line staff (narrow)"),

  /// 4-line staff (wide).
  staff4LinesWide("U+E019", null, "4-line staff (wide)"),

  /// 5-line staff.
  staff5Lines("U+E014", "U+1D11A", "5-line staff"),

  /// 5-line staff (narrow).
  staff5LinesNarrow("U+E020", null, "5-line staff (narrow)"),

  /// 5-line staff (wide).
  staff5LinesWide("U+E01A", null, "5-line staff (wide)"),

  /// 6-line staff.
  staff6Lines("U+E015", "U+1D11B", "6-line staff"),

  /// 6-line staff (narrow).
  staff6LinesNarrow("U+E021", null, "6-line staff (narrow)"),

  /// 6-line staff (wide).
  staff6LinesWide("U+E01B", null, "6-line staff (wide)"),

  /// Staff divide arrow down.
  staffDivideArrowDown("U+E00B", null, "Staff divide arrow down"),

  /// Staff divide arrow up.
  staffDivideArrowUp("U+E00C", null, "Staff divide arrow up"),

  /// Staff divide arrows.
  staffDivideArrowUpDown("U+E00D", null, "Staff divide arrows"),

  /// Lower 1 staff position.
  staffPosLower1("U+EB98", null, "Lower 1 staff position"),

  /// Lower 2 staff positions.
  staffPosLower2("U+EB99", null, "Lower 2 staff positions"),

  /// Lower 3 staff positions.
  staffPosLower3("U+EB9A", null, "Lower 3 staff positions"),

  /// Lower 4 staff positions.
  staffPosLower4("U+EB9B", null, "Lower 4 staff positions"),

  /// Lower 5 staff positions.
  staffPosLower5("U+EB9C", null, "Lower 5 staff positions"),

  /// Lower 6 staff positions.
  staffPosLower6("U+EB9D", null, "Lower 6 staff positions"),

  /// Lower 7 staff positions.
  staffPosLower7("U+EB9E", null, "Lower 7 staff positions"),

  /// Lower 8 staff positions.
  staffPosLower8("U+EB9F", null, "Lower 8 staff positions"),

  /// Raise 1 staff position.
  staffPosRaise1("U+EB90", null, "Raise 1 staff position"),

  /// Raise 2 staff positions.
  staffPosRaise2("U+EB91", null, "Raise 2 staff positions"),

  /// Raise 3 staff positions.
  staffPosRaise3("U+EB92", null, "Raise 3 staff positions"),

  /// Raise 4 staff positions.
  staffPosRaise4("U+EB93", null, "Raise 4 staff positions"),

  /// Raise 5 staff positions.
  staffPosRaise5("U+EB94", null, "Raise 5 staff positions"),

  /// Raise 6 staff positions.
  staffPosRaise6("U+EB95", null, "Raise 6 staff positions"),

  /// Raise 7 staff positions.
  staffPosRaise7("U+EB96", null, "Raise 7 staff positions"),

  /// Raise 8 staff positions.
  staffPosRaise8("U+EB97", null, "Raise 8 staff positions"),

  /// Combining stem.
  stem("U+E210", "U+1D165", "Combining stem"),

  /// Combining bow on bridge stem.
  stemBowOnBridge("U+E215", null, "Combining bow on bridge stem"),

  /// Combining bow on tailpiece stem.
  stemBowOnTailpiece("U+E216", null, "Combining bow on tailpiece stem"),

  /// Combining buzz roll stem.
  stemBuzzRoll("U+E217", null, "Combining buzz roll stem"),

  /// Combining damp stem.
  stemDamp("U+E218", null, "Combining damp stem"),

  /// Combining harp string noise stem.
  stemHarpStringNoise("U+E21F", null, "Combining harp string noise stem"),

  /// Combining multiphonics (black) stem.
  stemMultiphonicsBlack("U+E21A", null, "Combining multiphonics (black) stem"),

  /// Combining multiphonics (black and white) stem.
  stemMultiphonicsBlackWhite(
      "U+E21C", null, "Combining multiphonics (black and white) stem"),

  /// Combining multiphonics (white) stem.
  stemMultiphonicsWhite("U+E21B", null, "Combining multiphonics (white) stem"),

  /// Combining Penderecki unmeasured tremolo stem.
  stemPendereckiTremolo(
      "U+E213", null, "Combining Penderecki unmeasured tremolo stem"),

  /// Combining rim shot stem.
  stemRimShot("U+E21E", null, "Combining rim shot stem"),

  /// Combining sprechgesang stem.
  stemSprechgesang("U+E211", "U+1D166", "Combining sprechgesang stem"),

  /// Combining sul ponticello (bow behind bridge) stem.
  stemSulPonticello(
      "U+E214", null, "Combining sul ponticello (bow behind bridge) stem"),

  /// Combining sussurando stem.
  stemSussurando("U+E21D", null, "Combining sussurando stem"),

  /// Combining swished stem.
  stemSwished("U+E212", null, "Combining swished stem"),

  /// Combining vibrato pulse accent (Saunders) stem.
  stemVibratoPulse(
      "U+E219", null, "Combining vibrato pulse accent (Saunders) stem"),

  /// Stockhausen irregular tremolo ("Morsen", like Morse code).
  stockhausenTremolo("U+E232", null,
      "Stockhausen irregular tremolo (\"Morsen\", like Morse code)"),

  /// Bow behind bridge (sul ponticello).
  stringsBowBehindBridge("U+E618", null, "Bow behind bridge (sul ponticello)"),

  /// Bow behind bridge on four strings.
  stringsBowBehindBridgeFourStrings(
      "U+E62A", null, "Bow behind bridge on four strings"),

  /// Bow behind bridge on one string.
  stringsBowBehindBridgeOneString(
      "U+E627", null, "Bow behind bridge on one string"),

  /// Bow behind bridge on three strings.
  stringsBowBehindBridgeThreeStrings(
      "U+E629", null, "Bow behind bridge on three strings"),

  /// Bow behind bridge on two strings.
  stringsBowBehindBridgeTwoStrings(
      "U+E628", null, "Bow behind bridge on two strings"),

  /// Bow on top of bridge.
  stringsBowOnBridge("U+E619", null, "Bow on top of bridge"),

  /// Bow on tailpiece.
  stringsBowOnTailpiece("U+E61A", null, "Bow on tailpiece"),

  /// Change bow direction, indeterminate.
  stringsChangeBowDirection(
      "U+E626", null, "Change bow direction, indeterminate"),

  /// Down bow.
  stringsDownBow("U+E610", "U+1D1AA", "Down bow"),

  /// Down bow, away from body.
  stringsDownBowAwayFromBody("U+EE82", null, "Down bow, away from body"),

  /// Down bow, beyond bridge.
  stringsDownBowBeyondBridge("U+EE84", null, "Down bow, beyond bridge"),

  /// Down bow, towards body.
  stringsDownBowTowardsBody("U+EE80", null, "Down bow, towards body"),

  /// Turned down bow.
  stringsDownBowTurned("U+E611", null, "Turned down bow"),

  /// Fouetté.
  stringsFouette("U+E622", null, "Fouetté"),

  /// Half-harmonic.
  stringsHalfHarmonic("U+E615", null, "Half-harmonic"),

  /// Harmonic.
  stringsHarmonic("U+E614", "U+1D1AC", "Harmonic"),

  /// Jeté (gettato) above.
  stringsJeteAbove("U+E620", null, "Jeté (gettato) above"),

  /// Jeté (gettato) below.
  stringsJeteBelow("U+E621", null, "Jeté (gettato) below"),

  /// Mute off.
  stringsMuteOff("U+E617", null, "Mute off"),

  /// Mute on.
  stringsMuteOn("U+E616", null, "Mute on"),

  /// Overpressure, down bow.
  stringsOverpressureDownBow("U+E61B", null, "Overpressure, down bow"),

  /// Overpressure, no bow direction.
  stringsOverpressureNoDirection(
      "U+E61F", null, "Overpressure, no bow direction"),

  /// Overpressure possibile, down bow.
  stringsOverpressurePossibileDownBow(
      "U+E61D", null, "Overpressure possibile, down bow"),

  /// Overpressure possibile, up bow.
  stringsOverpressurePossibileUpBow(
      "U+E61E", null, "Overpressure possibile, up bow"),

  /// Overpressure, up bow.
  stringsOverpressureUpBow("U+E61C", null, "Overpressure, up bow"),

  /// Scrape, circular clockwise.
  stringsScrapeCircularClockwise("U+EE88", null, "Scrape, circular clockwise"),

  /// Scrape, circular counter-clockwise.
  stringsScrapeCircularCounterclockwise(
      "U+EE89", null, "Scrape, circular counter-clockwise"),

  /// Scrape, parallel inward.
  stringsScrapeParallelInward("U+EE86", null, "Scrape, parallel inward"),

  /// Scrape, parallel outward.
  stringsScrapeParallelOutward("U+EE87", null, "Scrape, parallel outward"),

  /// Thumb position.
  stringsThumbPosition("U+E624", null, "Thumb position"),

  /// Turned thumb position.
  stringsThumbPositionTurned("U+E625", null, "Turned thumb position"),

  /// Triple chop, inward.
  stringsTripleChopInward("U+EE8A", null, "Triple chop, inward"),

  /// Triple chop, outward.
  stringsTripleChopOutward("U+EE8B", null, "Triple chop, outward"),

  /// Up bow.
  stringsUpBow("U+E612", "U+1D1AB", "Up bow"),

  /// Up bow, away from body.
  stringsUpBowAwayFromBody("U+EE83", null, "Up bow, away from body"),

  /// Up bow, beyond bridge.
  stringsUpBowBeyondBridge("U+EE85", null, "Up bow, beyond bridge"),

  /// Up bow, towards body.
  stringsUpBowTowardsBody("U+EE81", null, "Up bow, towards body"),

  /// Turned up bow.
  stringsUpBowTurned("U+E613", null, "Turned up bow"),

  /// Vibrato pulse accent (Saunders) for stem.
  stringsVibratoPulse(
      "U+E623", null, "Vibrato pulse accent (Saunders) for stem"),

  /// Swiss rudiments doublé black notehead.
  swissRudimentsNoteheadBlackDouble(
      "U+EE72", null, "Swiss rudiments doublé black notehead"),

  /// Swiss rudiments flam black notehead.
  swissRudimentsNoteheadBlackFlam(
      "U+EE70", null, "Swiss rudiments flam black notehead"),

  /// Swiss rudiments doublé half (minim) notehead.
  swissRudimentsNoteheadHalfDouble(
      "U+EE73", null, "Swiss rudiments doublé half (minim) notehead"),

  /// Swiss rudiments flam half (minim) notehead.
  swissRudimentsNoteheadHalfFlam(
      "U+EE71", null, "Swiss rudiments flam half (minim) notehead"),

  /// System divider.
  systemDivider("U+E007", null, "System divider"),

  /// Extra long system divider.
  systemDividerExtraLong("U+E009", null, "Extra long system divider"),

  /// Long system divider.
  systemDividerLong("U+E008", null, "Long system divider"),

  /// Augmentation dot.
  textAugmentationDot("U+E1FC", null, "Augmentation dot"),

  /// Black note, fractional 16th beam, long stem.
  textBlackNoteFrac16thLongStem(
      "U+E1F5", null, "Black note, fractional 16th beam, long stem"),

  /// Black note, fractional 16th beam, short stem.
  textBlackNoteFrac16thShortStem(
      "U+E1F4", null, "Black note, fractional 16th beam, short stem"),

  /// Black note, fractional 32nd beam, long stem.
  textBlackNoteFrac32ndLongStem(
      "U+E1F6", null, "Black note, fractional 32nd beam, long stem"),

  /// Black note, fractional 8th beam, long stem.
  textBlackNoteFrac8thLongStem(
      "U+E1F3", null, "Black note, fractional 8th beam, long stem"),

  /// Black note, fractional 8th beam, short stem.
  textBlackNoteFrac8thShortStem(
      "U+E1F2", null, "Black note, fractional 8th beam, short stem"),

  /// Black note, long stem.
  textBlackNoteLongStem("U+E1F1", null, "Black note, long stem"),

  /// Black note, short stem.
  textBlackNoteShortStem("U+E1F0", null, "Black note, short stem"),

  /// Continuing 16th beam for long stem.
  textCont16thBeamLongStem(
      "U+E1FA", null, "Continuing 16th beam for long stem"),

  /// Continuing 16th beam for short stem.
  textCont16thBeamShortStem(
      "U+E1F9", null, "Continuing 16th beam for short stem"),

  /// Continuing 32nd beam for long stem.
  textCont32ndBeamLongStem(
      "U+E1FB", null, "Continuing 32nd beam for long stem"),

  /// Continuing 8th beam for long stem.
  textCont8thBeamLongStem("U+E1F8", null, "Continuing 8th beam for long stem"),

  /// Continuing 8th beam for short stem.
  textCont8thBeamShortStem(
      "U+E1F7", null, "Continuing 8th beam for short stem"),

  /// Headless black note, fractional 16th beam, long stem.
  textHeadlessBlackNoteFrac16thLongStem(
      "U+E209", null, "Headless black note, fractional 16th beam, long stem"),

  /// Headless black note, fractional 16th beam, short stem.
  textHeadlessBlackNoteFrac16thShortStem(
      "U+E208", null, "Headless black note, fractional 16th beam, short stem"),

  /// Headless black note, fractional 32nd beam, long stem.
  textHeadlessBlackNoteFrac32ndLongStem(
      "U+E20A", null, "Headless black note, fractional 32nd beam, long stem"),

  /// Headless black note, fractional 8th beam, long stem.
  textHeadlessBlackNoteFrac8thLongStem(
      "U+E207", null, "Headless black note, fractional 8th beam, long stem"),

  /// Headless black note, fractional 8th beam, short stem.
  textHeadlessBlackNoteFrac8thShortStem(
      "U+E206", null, "Headless black note, fractional 8th beam, short stem"),

  /// Headless black note, long stem.
  textHeadlessBlackNoteLongStem(
      "U+E205", null, "Headless black note, long stem"),

  /// Headless black note, short stem.
  textHeadlessBlackNoteShortStem(
      "U+E204", null, "Headless black note, short stem"),

  /// Tie.
  textTie("U+E1FD", null, "Tie"),

  /// Tuplet number 3 for long stem.
  textTuplet3LongStem("U+E202", null, "Tuplet number 3 for long stem"),

  /// Tuplet number 3 for short stem.
  textTuplet3ShortStem("U+E1FF", null, "Tuplet number 3 for short stem"),

  /// Tuplet bracket end for long stem.
  textTupletBracketEndLongStem(
      "U+E203", null, "Tuplet bracket end for long stem"),

  /// Tuplet bracket end for short stem.
  textTupletBracketEndShortStem(
      "U+E200", null, "Tuplet bracket end for short stem"),

  /// Tuplet bracket start for long stem.
  textTupletBracketStartLongStem(
      "U+E201", null, "Tuplet bracket start for long stem"),

  /// Tuplet bracket start for short stem.
  textTupletBracketStartShortStem(
      "U+E1FE", null, "Tuplet bracket start for short stem"),

  /// Time signature 0.
  timeSig0("U+E080", null, "Time signature 0"),

  /// Reversed time signature 0.
  timeSig0Reversed("U+ECF0", null, "Reversed time signature 0"),

  /// Turned time signature 0.
  timeSig0Turned("U+ECE0", null, "Turned time signature 0"),

  /// Time signature 1.
  timeSig1("U+E081", null, "Time signature 1"),

  /// Reversed time signature 1.
  timeSig1Reversed("U+ECF1", null, "Reversed time signature 1"),

  /// Turned time signature 1.
  timeSig1Turned("U+ECE1", null, "Turned time signature 1"),

  /// Time signature 2.
  timeSig2("U+E082", null, "Time signature 2"),

  /// Reversed time signature 2.
  timeSig2Reversed("U+ECF2", null, "Reversed time signature 2"),

  /// Turned time signature 2.
  timeSig2Turned("U+ECE2", null, "Turned time signature 2"),

  /// Time signature 3.
  timeSig3("U+E083", null, "Time signature 3"),

  /// Reversed time signature 3.
  timeSig3Reversed("U+ECF3", null, "Reversed time signature 3"),

  /// Turned time signature 3.
  timeSig3Turned("U+ECE3", null, "Turned time signature 3"),

  /// Time signature 4.
  timeSig4("U+E084", null, "Time signature 4"),

  /// Reversed time signature 4.
  timeSig4Reversed("U+ECF4", null, "Reversed time signature 4"),

  /// Turned time signature 4.
  timeSig4Turned("U+ECE4", null, "Turned time signature 4"),

  /// Time signature 5.
  timeSig5("U+E085", null, "Time signature 5"),

  /// Reversed time signature 5.
  timeSig5Reversed("U+ECF5", null, "Reversed time signature 5"),

  /// Turned time signature 5.
  timeSig5Turned("U+ECE5", null, "Turned time signature 5"),

  /// Time signature 6.
  timeSig6("U+E086", null, "Time signature 6"),

  /// Reversed time signature 6.
  timeSig6Reversed("U+ECF6", null, "Reversed time signature 6"),

  /// Turned time signature 6.
  timeSig6Turned("U+ECE6", null, "Turned time signature 6"),

  /// Time signature 7.
  timeSig7("U+E087", null, "Time signature 7"),

  /// Reversed time signature 7.
  timeSig7Reversed("U+ECF7", null, "Reversed time signature 7"),

  /// Turned time signature 7.
  timeSig7Turned("U+ECE7", null, "Turned time signature 7"),

  /// Time signature 8.
  timeSig8("U+E088", null, "Time signature 8"),

  /// Reversed time signature 8.
  timeSig8Reversed("U+ECF8", null, "Reversed time signature 8"),

  /// Turned time signature 8.
  timeSig8Turned("U+ECE8", null, "Turned time signature 8"),

  /// Time signature 9.
  timeSig9("U+E089", null, "Time signature 9"),

  /// Reversed time signature 9.
  timeSig9Reversed("U+ECF9", null, "Reversed time signature 9"),

  /// Turned time signature 9.
  timeSig9Turned("U+ECE9", null, "Turned time signature 9"),

  /// Left bracket for whole time signature.
  timeSigBracketLeft("U+EC80", null, "Left bracket for whole time signature"),

  /// Left bracket for numerator only.
  timeSigBracketLeftSmall("U+EC82", null, "Left bracket for numerator only"),

  /// Right bracket for whole time signature.
  timeSigBracketRight("U+EC81", null, "Right bracket for whole time signature"),

  /// Right bracket for numerator only.
  timeSigBracketRightSmall("U+EC83", null, "Right bracket for numerator only"),

  /// Control character for denominator digit.
  timeSigCombDenominator(
      "U+E09F", null, "Control character for denominator digit"),

  /// Control character for numerator digit.
  timeSigCombNumerator("U+E09E", null, "Control character for numerator digit"),

  /// Time signature comma.
  timeSigComma("U+E096", null, "Time signature comma"),

  /// Common time.
  timeSigCommon("U+E08A", "U+1D134", "Common time"),

  /// Reversed common time.
  timeSigCommonReversed("U+ECFA", null, "Reversed common time"),

  /// Turned common time.
  timeSigCommonTurned("U+ECEA", null, "Turned common time"),

  /// Cut time (Bach).
  timeSigCut2("U+EC85", null, "Cut time (Bach)"),

  /// Cut triple time (9/8).
  timeSigCut3("U+EC86", null, "Cut triple time (9/8)"),

  /// Cut time.
  timeSigCutCommon("U+E08B", "U+1D135", "Cut time"),

  /// Reversed cut time.
  timeSigCutCommonReversed("U+ECFB", null, "Reversed cut time"),

  /// Turned cut time.
  timeSigCutCommonTurned("U+ECEB", null, "Turned cut time"),

  /// Time signature equals.
  timeSigEquals("U+E08F", null, "Time signature equals"),

  /// Time signature fraction ½.
  timeSigFractionHalf("U+E098", null, "Time signature fraction ½"),

  /// Time signature fraction ⅓.
  timeSigFractionOneThird("U+E09A", null, "Time signature fraction ⅓"),

  /// Time signature fraction ¼.
  timeSigFractionQuarter("U+E097", null, "Time signature fraction ¼"),

  /// Time signature fraction ¾.
  timeSigFractionThreeQuarters("U+E099", null, "Time signature fraction ¾"),

  /// Time signature fraction ⅔.
  timeSigFractionTwoThirds("U+E09B", null, "Time signature fraction ⅔"),

  /// Time signature fraction slash.
  timeSigFractionalSlash("U+E08E", null, "Time signature fraction slash"),

  /// Time signature minus.
  timeSigMinus("U+E090", null, "Time signature minus"),

  /// Time signature multiply.
  timeSigMultiply("U+E091", null, "Time signature multiply"),

  /// Open time signature (Penderecki).
  timeSigOpenPenderecki("U+E09D", null, "Open time signature (Penderecki)"),

  /// Left parenthesis for whole time signature.
  timeSigParensLeft(
      "U+E094", null, "Left parenthesis for whole time signature"),

  /// Left parenthesis for numerator only.
  timeSigParensLeftSmall("U+E092", null, "Left parenthesis for numerator only"),

  /// Right parenthesis for whole time signature.
  timeSigParensRight(
      "U+E095", null, "Right parenthesis for whole time signature"),

  /// Right parenthesis for numerator only.
  timeSigParensRightSmall(
      "U+E093", null, "Right parenthesis for numerator only"),

  /// Time signature +.
  timeSigPlus("U+E08C", null, "Time signature +"),

  /// Time signature + (for numerators).
  timeSigPlusSmall("U+E08D", null, "Time signature + (for numerators)"),

  /// Time signature slash separator.
  timeSigSlash("U+EC84", null, "Time signature slash separator"),

  /// Open time signature.
  timeSigX("U+E09C", null, "Open time signature"),

  /// Combining tremolo 1.
  tremolo1("U+E220", "U+1D167", "Combining tremolo 1"),

  /// Combining tremolo 2.
  tremolo2("U+E221", "U+1D168", "Combining tremolo 2"),

  /// Combining tremolo 3.
  tremolo3("U+E222", "U+1D169", "Combining tremolo 3"),

  /// Combining tremolo 4.
  tremolo4("U+E223", null, "Combining tremolo 4"),

  /// Combining tremolo 5.
  tremolo5("U+E224", null, "Combining tremolo 5"),

  /// Divide measured tremolo by 2.
  tremoloDivisiDots2("U+E22E", null, "Divide measured tremolo by 2"),

  /// Divide measured tremolo by 3.
  tremoloDivisiDots3("U+E22F", null, "Divide measured tremolo by 3"),

  /// Divide measured tremolo by 4.
  tremoloDivisiDots4("U+E230", null, "Divide measured tremolo by 4"),

  /// Divide measured tremolo by 6.
  tremoloDivisiDots6("U+E231", null, "Divide measured tremolo by 6"),

  /// Fingered tremolo 1.
  tremoloFingered1("U+E225", "U+1D16A", "Fingered tremolo 1"),

  /// Fingered tremolo 2.
  tremoloFingered2("U+E226", "U+1D16B", "Fingered tremolo 2"),

  /// Fingered tremolo 3.
  tremoloFingered3("U+E227", "U+1D16C", "Fingered tremolo 3"),

  /// Fingered tremolo 4.
  tremoloFingered4("U+E228", null, "Fingered tremolo 4"),

  /// Fingered tremolo 5.
  tremoloFingered5("U+E229", null, "Fingered tremolo 5"),

  /// Triple-tongue above.
  tripleTongueAbove("U+E5F2", "U+1D18B", "Triple-tongue above"),

  /// Triple-tongue below.
  tripleTongueBelow("U+E5F3", null, "Triple-tongue below"),

  /// Tuplet 0.
  tuplet0("U+E880", null, "Tuplet 0"),

  /// Tuplet 1.
  tuplet1("U+E881", null, "Tuplet 1"),

  /// Tuplet 2.
  tuplet2("U+E882", null, "Tuplet 2"),

  /// Tuplet 3.
  tuplet3("U+E883", null, "Tuplet 3"),

  /// Tuplet 4.
  tuplet4("U+E884", null, "Tuplet 4"),

  /// Tuplet 5.
  tuplet5("U+E885", null, "Tuplet 5"),

  /// Tuplet 6.
  tuplet6("U+E886", null, "Tuplet 6"),

  /// Tuplet 7.
  tuplet7("U+E887", null, "Tuplet 7"),

  /// Tuplet 8.
  tuplet8("U+E888", null, "Tuplet 8"),

  /// Tuplet 9.
  tuplet9("U+E889", null, "Tuplet 9"),

  /// Tuplet colon.
  tupletColon("U+E88A", null, "Tuplet colon"),

  /// Wieniawski unmeasured tremolo.
  unmeasuredTremolo("U+E22C", null, "Wieniawski unmeasured tremolo"),

  /// Wieniawski unmeasured tremolo (simpler).
  unmeasuredTremoloSimple(
      "U+E22D", null, "Wieniawski unmeasured tremolo (simpler)"),

  /// Unpitched percussion clef 1.
  unpitchedPercussionClef1("U+E069", "U+1D125", "Unpitched percussion clef 1"),

  /// Unpitched percussion clef 2.
  unpitchedPercussionClef2("U+E06A", "U+1D126", "Unpitched percussion clef 2"),

  /// Ventiduesima.
  ventiduesima("U+E517", null, "Ventiduesima"),

  /// Ventiduesima alta.
  ventiduesimaAlta("U+E518", null, "Ventiduesima alta"),

  /// Ventiduesima bassa.
  ventiduesimaBassa("U+E519", null, "Ventiduesima bassa"),

  /// Ventiduesima bassa (mb).
  ventiduesimaBassaMb("U+E51E", null, "Ventiduesima bassa (mb)"),

  /// Finger click (Stockhausen).
  vocalFingerClickStockhausen("U+E649", null, "Finger click (Stockhausen)"),

  /// Halb gesungen (semi-sprechgesang).
  vocalHalbGesungen("U+E64B", null, "Halb gesungen (semi-sprechgesang)"),

  /// Mouth closed.
  vocalMouthClosed("U+E640", null, "Mouth closed"),

  /// Mouth open.
  vocalMouthOpen("U+E642", null, "Mouth open"),

  /// Mouth pursed.
  vocalMouthPursed("U+E644", null, "Mouth pursed"),

  /// Mouth slightly open.
  vocalMouthSlightlyOpen("U+E641", null, "Mouth slightly open"),

  /// Mouth wide open.
  vocalMouthWideOpen("U+E643", null, "Mouth wide open"),

  /// Nasal voice.
  vocalNasalVoice("U+E647", null, "Nasal voice"),

  /// Sprechgesang.
  vocalSprechgesang("U+E645", null, "Sprechgesang"),

  /// Tongue click (Stockhausen).
  vocalTongueClickStockhausen("U+E648", null, "Tongue click (Stockhausen)"),

  /// Tongue and finger click (Stockhausen).
  vocalTongueFingerClickStockhausen(
      "U+E64A", null, "Tongue and finger click (Stockhausen)"),

  /// Combining sussurando for stem.
  vocalsSussurando("U+E646", null, "Combining sussurando for stem"),

  /// Arpeggiato wiggle segment, downwards.
  wiggleArpeggiatoDown("U+EAAA", null, "Arpeggiato wiggle segment, downwards"),

  /// Arpeggiato arrowhead down.
  wiggleArpeggiatoDownArrow("U+EAAE", null, "Arpeggiato arrowhead down"),

  /// Arpeggiato downward swash.
  wiggleArpeggiatoDownSwash("U+EAAC", null, "Arpeggiato downward swash"),

  /// Arpeggiato wiggle segment, upwards.
  wiggleArpeggiatoUp("U+EAA9", null, "Arpeggiato wiggle segment, upwards"),

  /// Arpeggiato arrowhead up.
  wiggleArpeggiatoUpArrow("U+EAAD", null, "Arpeggiato arrowhead up"),

  /// Arpeggiato upward swash.
  wiggleArpeggiatoUpSwash("U+EAAB", null, "Arpeggiato upward swash"),

  /// Circular motion segment.
  wiggleCircular("U+EAC9", null, "Circular motion segment"),

  /// Constant circular motion segment.
  wiggleCircularConstant("U+EAC0", null, "Constant circular motion segment"),

  /// Constant circular motion segment (flipped).
  wiggleCircularConstantFlipped(
      "U+EAC1", null, "Constant circular motion segment (flipped)"),

  /// Constant circular motion segment (flipped, large).
  wiggleCircularConstantFlippedLarge(
      "U+EAC3", null, "Constant circular motion segment (flipped, large)"),

  /// Constant circular motion segment (large).
  wiggleCircularConstantLarge(
      "U+EAC2", null, "Constant circular motion segment (large)"),

  /// Circular motion end.
  wiggleCircularEnd("U+EACB", null, "Circular motion end"),

  /// Circular motion segment, large.
  wiggleCircularLarge("U+EAC8", null, "Circular motion segment, large"),

  /// Circular motion segment, larger.
  wiggleCircularLarger("U+EAC7", null, "Circular motion segment, larger"),

  /// Circular motion segment, larger still.
  wiggleCircularLargerStill(
      "U+EAC6", null, "Circular motion segment, larger still"),

  /// Circular motion segment, largest.
  wiggleCircularLargest("U+EAC5", null, "Circular motion segment, largest"),

  /// Circular motion segment, small.
  wiggleCircularSmall("U+EACA", null, "Circular motion segment, small"),

  /// Circular motion start.
  wiggleCircularStart("U+EAC4", null, "Circular motion start"),

  /// Glissando wiggle segment.
  wiggleGlissando("U+EAAF", null, "Glissando wiggle segment"),

  /// Group glissando 1.
  wiggleGlissandoGroup1("U+EABD", null, "Group glissando 1"),

  /// Group glissando 2.
  wiggleGlissandoGroup2("U+EABE", null, "Group glissando 2"),

  /// Group glissando 3.
  wiggleGlissandoGroup3("U+EABF", null, "Group glissando 3"),

  /// Quasi-random squiggle 1.
  wiggleRandom1("U+EAF0", null, "Quasi-random squiggle 1"),

  /// Quasi-random squiggle 2.
  wiggleRandom2("U+EAF1", null, "Quasi-random squiggle 2"),

  /// Quasi-random squiggle 3.
  wiggleRandom3("U+EAF2", null, "Quasi-random squiggle 3"),

  /// Quasi-random squiggle 4.
  wiggleRandom4("U+EAF3", null, "Quasi-random squiggle 4"),

  /// Sawtooth line segment.
  wiggleSawtooth("U+EABB", null, "Sawtooth line segment"),

  /// Narrow sawtooth line segment.
  wiggleSawtoothNarrow("U+EABA", null, "Narrow sawtooth line segment"),

  /// Wide sawtooth line segment.
  wiggleSawtoothWide("U+EABC", null, "Wide sawtooth line segment"),

  /// Square wave line segment.
  wiggleSquareWave("U+EAB8", null, "Square wave line segment"),

  /// Narrow square wave line segment.
  wiggleSquareWaveNarrow("U+EAB7", null, "Narrow square wave line segment"),

  /// Wide square wave line segment.
  wiggleSquareWaveWide("U+EAB9", null, "Wide square wave line segment"),

  /// Trill wiggle segment.
  wiggleTrill("U+EAA4", null, "Trill wiggle segment"),

  /// Trill wiggle segment, fast.
  wiggleTrillFast("U+EAA3", null, "Trill wiggle segment, fast"),

  /// Trill wiggle segment, faster.
  wiggleTrillFaster("U+EAA2", null, "Trill wiggle segment, faster"),

  /// Trill wiggle segment, faster still.
  wiggleTrillFasterStill("U+EAA1", null, "Trill wiggle segment, faster still"),

  /// Trill wiggle segment, fastest.
  wiggleTrillFastest("U+EAA0", null, "Trill wiggle segment, fastest"),

  /// Trill wiggle segment, slow.
  wiggleTrillSlow("U+EAA5", null, "Trill wiggle segment, slow"),

  /// Trill wiggle segment, slower.
  wiggleTrillSlower("U+EAA6", null, "Trill wiggle segment, slower"),

  /// Trill wiggle segment, slower still.
  wiggleTrillSlowerStill("U+EAA7", null, "Trill wiggle segment, slower still"),

  /// Trill wiggle segment, slowest.
  wiggleTrillSlowest("U+EAA8", null, "Trill wiggle segment, slowest"),

  /// Vibrato largest, slower.
  wiggleVIbratoLargestSlower("U+EAEE", null, "Vibrato largest, slower"),

  /// Vibrato medium, slower.
  wiggleVIbratoMediumSlower("U+EAE0", null, "Vibrato medium, slower"),

  /// Vibrato / shake wiggle segment.
  wiggleVibrato("U+EAB0", null, "Vibrato / shake wiggle segment"),

  /// Vibrato large, fast.
  wiggleVibratoLargeFast("U+EAE5", null, "Vibrato large, fast"),

  /// Vibrato large, faster.
  wiggleVibratoLargeFaster("U+EAE4", null, "Vibrato large, faster"),

  /// Vibrato large, faster still.
  wiggleVibratoLargeFasterStill("U+EAE3", null, "Vibrato large, faster still"),

  /// Vibrato large, fastest.
  wiggleVibratoLargeFastest("U+EAE2", null, "Vibrato large, fastest"),

  /// Vibrato large, slow.
  wiggleVibratoLargeSlow("U+EAE6", null, "Vibrato large, slow"),

  /// Vibrato large, slower.
  wiggleVibratoLargeSlower("U+EAE7", null, "Vibrato large, slower"),

  /// Vibrato large, slowest.
  wiggleVibratoLargeSlowest("U+EAE8", null, "Vibrato large, slowest"),

  /// Vibrato largest, fast.
  wiggleVibratoLargestFast("U+EAEC", null, "Vibrato largest, fast"),

  /// Vibrato largest, faster.
  wiggleVibratoLargestFaster("U+EAEB", null, "Vibrato largest, faster"),

  /// Vibrato largest, faster still.
  wiggleVibratoLargestFasterStill(
      "U+EAEA", null, "Vibrato largest, faster still"),

  /// Vibrato largest, fastest.
  wiggleVibratoLargestFastest("U+EAE9", null, "Vibrato largest, fastest"),

  /// Vibrato largest, slow.
  wiggleVibratoLargestSlow("U+EAED", null, "Vibrato largest, slow"),

  /// Vibrato largest, slowest.
  wiggleVibratoLargestSlowest("U+EAEF", null, "Vibrato largest, slowest"),

  /// Vibrato medium, fast.
  wiggleVibratoMediumFast("U+EADE", null, "Vibrato medium, fast"),

  /// Vibrato medium, faster.
  wiggleVibratoMediumFaster("U+EADD", null, "Vibrato medium, faster"),

  /// Vibrato medium, faster still.
  wiggleVibratoMediumFasterStill(
      "U+EADC", null, "Vibrato medium, faster still"),

  /// Vibrato medium, fastest.
  wiggleVibratoMediumFastest("U+EADB", null, "Vibrato medium, fastest"),

  /// Vibrato medium, slow.
  wiggleVibratoMediumSlow("U+EADF", null, "Vibrato medium, slow"),

  /// Vibrato medium, slowest.
  wiggleVibratoMediumSlowest("U+EAE1", null, "Vibrato medium, slowest"),

  /// Vibrato small, fast.
  wiggleVibratoSmallFast("U+EAD7", null, "Vibrato small, fast"),

  /// Vibrato small, faster.
  wiggleVibratoSmallFaster("U+EAD6", null, "Vibrato small, faster"),

  /// Vibrato small, faster still.
  wiggleVibratoSmallFasterStill("U+EAD5", null, "Vibrato small, faster still"),

  /// Vibrato small, fastest.
  wiggleVibratoSmallFastest("U+EAD4", null, "Vibrato small, fastest"),

  /// Vibrato small, slow.
  wiggleVibratoSmallSlow("U+EAD8", null, "Vibrato small, slow"),

  /// Vibrato small, slower.
  wiggleVibratoSmallSlower("U+EAD9", null, "Vibrato small, slower"),

  /// Vibrato small, slowest.
  wiggleVibratoSmallSlowest("U+EADA", null, "Vibrato small, slowest"),

  /// Vibrato smallest, fast.
  wiggleVibratoSmallestFast("U+EAD0", null, "Vibrato smallest, fast"),

  /// Vibrato smallest, faster.
  wiggleVibratoSmallestFaster("U+EACF", null, "Vibrato smallest, faster"),

  /// Vibrato smallest, faster still.
  wiggleVibratoSmallestFasterStill(
      "U+EACE", null, "Vibrato smallest, faster still"),

  /// Vibrato smallest, fastest.
  wiggleVibratoSmallestFastest("U+EACD", null, "Vibrato smallest, fastest"),

  /// Vibrato smallest, slow.
  wiggleVibratoSmallestSlow("U+EAD1", null, "Vibrato smallest, slow"),

  /// Vibrato smallest, slower.
  wiggleVibratoSmallestSlower("U+EAD2", null, "Vibrato smallest, slower"),

  /// Vibrato smallest, slowest.
  wiggleVibratoSmallestSlowest("U+EAD3", null, "Vibrato smallest, slowest"),

  /// Vibrato start.
  wiggleVibratoStart("U+EACC", null, "Vibrato start"),

  /// Wide vibrato / shake wiggle segment.
  wiggleVibratoWide("U+EAB1", null, "Wide vibrato / shake wiggle segment"),

  /// Wavy line segment.
  wiggleWavy("U+EAB5", null, "Wavy line segment"),

  /// Narrow wavy line segment.
  wiggleWavyNarrow("U+EAB4", null, "Narrow wavy line segment"),

  /// Wide wavy line segment.
  wiggleWavyWide("U+EAB6", null, "Wide wavy line segment"),

  /// Closed hole.
  windClosedHole("U+E5F4", null, "Closed hole"),

  /// Flatter embouchure.
  windFlatEmbouchure("U+E5FB", null, "Flatter embouchure"),

  /// Half-closed hole.
  windHalfClosedHole1("U+E5F6", null, "Half-closed hole"),

  /// Half-closed hole 2.
  windHalfClosedHole2("U+E5F7", null, "Half-closed hole 2"),

  /// Half-open hole.
  windHalfClosedHole3("U+E5F8", null, "Half-open hole"),

  /// Somewhat relaxed embouchure.
  windLessRelaxedEmbouchure("U+E5FE", null, "Somewhat relaxed embouchure"),

  /// Somewhat tight embouchure.
  windLessTightEmbouchure("U+E600", null, "Somewhat tight embouchure"),

  /// Mouthpiece or hand pop.
  windMouthpiecePop("U+E60A", null, "Mouthpiece or hand pop"),

  /// Combining multiphonics (black) for stem.
  windMultiphonicsBlackStem(
      "U+E607", null, "Combining multiphonics (black) for stem"),

  /// Combining multiphonics (black and white) for stem.
  windMultiphonicsBlackWhiteStem(
      "U+E609", null, "Combining multiphonics (black and white) for stem"),

  /// Combining multiphonics (white) for stem.
  windMultiphonicsWhiteStem(
      "U+E608", null, "Combining multiphonics (white) for stem"),

  /// Open hole.
  windOpenHole("U+E5F9", null, "Open hole"),

  /// Much more reed (push inwards).
  windReedPositionIn("U+E606", null, "Much more reed (push inwards)"),

  /// Normal reed position.
  windReedPositionNormal("U+E604", null, "Normal reed position"),

  /// Very little reed (pull outwards).
  windReedPositionOut("U+E605", null, "Very little reed (pull outwards)"),

  /// Relaxed embouchure.
  windRelaxedEmbouchure("U+E5FD", null, "Relaxed embouchure"),

  /// Rim only.
  windRimOnly("U+E60B", null, "Rim only"),

  /// Sharper embouchure.
  windSharpEmbouchure("U+E5FC", null, "Sharper embouchure"),

  /// Very tight embouchure / strong air pressure.
  windStrongAirPressure(
      "U+E603", null, "Very tight embouchure / strong air pressure"),

  /// Three-quarters closed hole.
  windThreeQuartersClosedHole("U+E5F5", null, "Three-quarters closed hole"),

  /// Tight embouchure.
  windTightEmbouchure("U+E5FF", null, "Tight embouchure"),

  /// Trill key.
  windTrillKey("U+E5FA", null, "Trill key"),

  /// Very tight embouchure.
  windVeryTightEmbouchure("U+E601", null, "Very tight embouchure"),

  /// Very relaxed embouchure / weak air-pressure.
  windWeakAirPressure(
      "U+E602", null, "Very relaxed embouchure / weak air-pressure");

  const SmuflGlyph(this.codepoint, this.alternateCodepoint, this.description);

  /// The Unicode codepoint value for the glyph.
  final String codepoint;

  /// An optional alternate Unicode codepoint value for the glyph.
  final String? alternateCodepoint;

  /// A description of the glyph.
  final String description;
}
