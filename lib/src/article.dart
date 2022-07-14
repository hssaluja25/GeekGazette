class Article {
  final String text;
  final String domain;
  final String by;
  final String age;
  final int score;
  final int commentsCount;

  const Article(
      {required this.text,
      required this.domain,
      required this.by,
      required this.age,
      required this.score,
      required this.commentsCount});
}

final articles = [
  const Article(
    text:
        "Circular Shock Acoustic Waves in Ionosphere Triggered by Launch of Formosat-5",
    domain: "wiley.com",
    by: "zdw",
    age: "3 hours",
    score: 177,
    commentsCount: 62,
  ),
  const Article(
    text: "BMW says electric car mass production not viable until 2020",
    domain: "reuters.com",
    by: "Mononokay",
    age: "2 hours",
    score: 81,
    commentsCount: 128,
  ),
  const Article(
    text: "Evolution Is the Deep Learning",
    domain: "sentient.ai",
    by: "jonbaer",
    age: "4 hours",
    score: 200,
    commentsCount: 87,
  ),
  const Article(
    text: "TCP Traceopoints hace arrived in Linux",
    domain: "brndangregg.com",
    by: "brendangregg",
    age: "1 hour",
    score: 35,
    commentsCount: 0,
  ),
  const Article(
    text:
        "Section 230: A Key Legal Shield for Facebook, Google Is About to Change",
    domain: "npr.org",
    by: "Monokay",
    age: "5 hours",
    score: 156,
    commentsCount: 66,
  ),
  const Article(
    text: "A Visiting Star Jostled Our Solar System 70,000 Years Ago",
    domain: "gizmodo.com",
    by: "rbanffy",
    age: "7 hours",
    score: 122,
    commentsCount: 43,
  ),
  const Article(
    text:
        "Number systems of the world, sorted by complexity of counting (2006)",
    domain: "airnet.ne.jp",
    by: "ColinWright",
    age: "8 hours",
    score: 196,
    commentsCount: 90,
  ),
  const Article(
    text: "MIT's device can pull water from desert air",
    domain: "techcrunch.com",
    by: "evo_9",
    age: "43 minutes",
    score: 11,
    commentsCount: 11,
  ),
  const Article(
    text:
        "TravisBuddy: Adds comments to failed pull requests, tells author what went wrong",
    domain: "github.com",
    by: "bluzzi",
    age: "8 hours",
    score: 37,
    commentsCount: 26,
  ),
  const Article(
    text: "Using Technical Debt in Your Favor",
    domain: "gitconnected.com",
    by: "treyhuffine",
    age: "7 hours",
    score: 140,
    commentsCount: 123,
  ),
];
