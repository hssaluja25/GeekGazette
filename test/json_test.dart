import 'package:flutter_test/flutter_test.dart';
import 'package:hackernews/json_parsing.dart';
import 'package:http/http.dart' as http;

void main() {
  // ! Difference between test and testWidgets?
  test("parses topstories.json", () {
    const jsonString =
        '[32084617,32085215,32086641,32081943,32086170,32085453,32081808,32084980,32080741,32085475,32081051,32085180,32080469,32081900,32084571,32086740,32085734,32079227,32066141,32053575,32079434,32067595,32084023,32083753,32081583,32080540,32082896,32080174,32080486,32084850,32068226,32086146,32082084,32074068,32069418,32084746,32068447,32062275,32086428,32084887,32072530,32082284,32042197,32086019,32067906,32077823,32084064,32082371,32085342,32059208,32086982,32083557,32085742,32085840,32067523,32087109,32085908,32052204,32087053,32083853,32080245,32081470,32053044,32078749,32083138,32078731,32086465,32051789,32033905,32078407,32071949,32086776,32078095,32084646,32081589,32075032,32068647,32081974,32081508,32071137,32081528,32081779,32084216,32085623,32081827,32077853,32077834,32043026,32081749,32069926,32082036,32077914,32077029,32080798,32077685,32074414,32057211,32084160,32076677,32071020,32077528,32043635,32083916,32075952,32080050,32067945,32085593,32066919,32080549,32067019,32035054,32080371,32066453,32067705,32066714,32080077,32078518,32081111,32077068,32064324,32081909,32076033,32080358,32055756,32052442,32073450,32070747,32053422,32077281,32034320,32083426,32071349,32067473,32071346,32082286,32077265,32076143,32071124,32084635,32079649,32040518,32084431,32081747,32067962,32070661,32068062,32065170,32080871,32048148,32066201,32072321,32070831,32065472,32059566,32067559,32053525,32054181,32052475,32077425,32070937,32058674,32067879,32043518,32066311,32053293,32073410,32062863,32059216,32081199,32070292,32080484,32079207,32080071,32065021,32033859,32062849,32051986,32056049,32069578,32074049,32065026,32083395,32072884,32041917,32079913,32074667,32068164,32078949,32062566,32083220,32053502,32027341,32078816,32051736,32083653,32063341,32066706,32043460,32078571,32072881,32064404,32079397,32056140,32075988,32034643,32055924,32053175,32056151,32053961,32070805,32061187,32082647,32043235,32052247,32054565,32082590,32049469,32043923,32049672,32067984,32069468,32068975,32054532,32040506,32085941,32080533,32068579,32064895,32042054,32047230,32043677,32042767,32053816,32066569,32063347,32040251,32074861,32037622,32071558,32057459,32076634,32066644,32080158,32043229,32055633,32074705,32075692,32043433,32033622,32071756,32043539,32043405,32061193,32081537,32003756,32054335,32038081,32067461,32081460,32057297,32045779,32026637,32073929,32077710,32072035,32052825,32047535,32080184,32060216,32075388,32080126,32056969,32074790,32076315,32077690,32053304,32048468,32068479,32074990,32057105,32045934,32069033,32081127,32078884,32064882,32033420,32034603,32033009,32074089,32073535,32036224,32034798,32057116,32077598,32059109,32050168,32080333,32074055,32066370,32052684,32063623,32083291,32057776,32068211,32077751,32079290,32078946,32040654,32053592,32070294,32046130,32069090,32074871,32049341,32045906,32035569,32068501,32045339,32070947,32049780,32080088,32043738,32053083,32032606,32076098,32079693,32071882,32003215,32053287,32059666,32049194,32018218,32071372,32033394,32041158,32037740,32017952,32079877,32077792,32031131,32045704,32052669,32073126,32060597,32060226,32073660,32080461,32052140,32063652,32079694,32065125,32076851,32076847,32034269,32036524,32074634,32071776,32064372,32083034,32068173,32073919,32037254,32018066,32046036,32037356,32077036,32077034,32058224,32043043,32056189,32078874,32062615,32032968,32002057,32026951,32008586,32036825,32038005,32021374,32036899,32063292,32047203,32033925,32077495,32071126,32025521,32075207,32029033,32051703,32040466,32012175,32043872,32032650,32057218,32064415,32042108,32065957,32011288,32013330,32075691,32052302,32010699,32016391,32069251,32042187,32035633,32075183,32036054,32066491,32045928,32037105,32057859,32021269,32078081,32066978,32035074,32070669,32025211,32070804,32023881,32037489,32001742,32031310,32066743,32037207,32056551,32041676,32032712,32066670,32034259,32057162,32031649,32014382,32011432,32028752,32032588,32039828,32042249,32035003,32032134,32036478,32078643,32011842,32034625,32009440,32075265,32025882,32074018,32036523,32077503,32037543,32077496,32033833,32073756,32073483,32033482,32044978,32034403,32050826,32077335,32059865,32078319,32032297,32034245,32010238,32049508,32032867,32044963,32038475,32072828,32057580,32067781,32033208,32049137,32051057,32077962,32033567,32066051,32033063,32045763,32061424,32037955,32016142,32005421,32030227,32068018,32053650,32062866,32067193,32078976,32042254,32074743,32043191,32071102,32037363,32033673,32035160,32066283,32020055,32076817]';
    // The first argument is actual. The second argument is matcher. Assert that actual matches matcher.
    expect(fromJson2ListOfTopStories(jsonString).first, 32084617);
  });

  test("parses item.json", () {
    const jsonString =
        '{"by":"dhouston","descendants":71,"id":8863,"kids":[9224,8917,8952,8958,8884,8887,8869,8873,8940,8908,9005,9671,9067,9055,8865,8881,8872,8955,10403,8903,8928,9125,8998,8901,8902,8907,8894,8870,8878,8980,8934,8943,8876],"score":104,"time":1175714200,"title":"My YC app: Dropbox - Throw away your USB drive","type":"story","url":"http://www.getdropbox.com/u/2/screencast.html"}';
    expect(fromJson2Article(jsonString).by, "dhouston");
  });

  test(
    "Parses item.json over a network",
    () async {
      final uri =
          Uri.parse('https://hacker-news.firebaseio.com/v0/item/8863.json');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        expect(fromJson2Article(response.body), isNotNull);
      }
    },
  );
}
