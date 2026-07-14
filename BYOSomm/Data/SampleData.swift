import Foundation
import SwiftData

struct SampleData {

    // MARK: — Wines (12)
    static var sampleWines: [Wine] {
        let fmt = ISO8601DateFormatter()
        func date(_ s: String) -> Date { fmt.date(from: s) ?? Date() }
        return [
            // REDS
            Wine(
                id: "sample-001",
                name: "Torbreck Woodcutter's Shiraz",
                type: .red, vintage: 2021,
                region: "Barossa Valley, SA", country: "Australia",
                grape: "Shiraz", producer: "Torbreck Vintners",
                body: 5, tannin: 4, acidity: 3, sweetness: 1,
                flavours: ["dark cherry", "blackberry", "cracked pepper", "liquorice", "mocha", "smoked meat"],
                foodPairings: ["Slow-roasted lamb", "Beef brisket", "Hard aged cheese", "Lamb shanks"],
                wineDescription: "A full-throttle Barossa Shiraz that showcases the region's trademark generosity. Inky and dense, with waves of dark fruit, Barossa's signature white pepper and savoury oak. The tannins are ripe and plush — built for the cellar but impressive now.",
                rating: 4, savedAt: date("2024-03-15T10:00:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-002",
                name: "Yangarra Estate Grenache",
                type: .red, vintage: 2022,
                region: "McLaren Vale, SA", country: "Australia",
                grape: "Grenache", producer: "Yangarra Estate",
                body: 3, tannin: 2, acidity: 3, sweetness: 1,
                flavours: ["raspberry", "pomegranate", "dried rose petal", "wild herbs", "white pepper", "kirsch"],
                foodPairings: ["Roast chicken", "Charcuterie board", "Pinot noir-style salmon", "Mushroom risotto"],
                wineDescription: "Old-vine Grenache from the rolling hills of McLaren Vale, vinified with a light touch to preserve freshness. Perfumed, silky and surprisingly elegant for the region, with vibrant raspberry fruit and a savoury, herb-tinged finish.",
                rating: 5, savedAt: date("2024-04-02T12:00:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-003",
                name: "Yering Station Pinot Noir",
                type: .red, vintage: 2022,
                region: "Yarra Valley, VIC", country: "Australia",
                grape: "Pinot Noir", producer: "Yering Station",
                body: 2, tannin: 2, acidity: 4, sweetness: 1,
                flavours: ["red cherry", "strawberry", "forest floor", "dried herbs", "subtle spice", "rose hip"],
                foodPairings: ["Duck breast", "Salmon fillet", "Mushroom pasta", "Roast quail"],
                wineDescription: "The cool Yarra Valley produces some of Australia's most refined Pinot Noir, and this is a textbook example. Translucent ruby in the glass with a nose of red cherry and forest floor. On the palate it's silky, bright and persistent — the hallmark of cool-climate finesse.",
                rating: 4, savedAt: date("2024-05-10T09:30:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-004",
                name: "Vasse Felix Cabernet Sauvignon",
                type: .red, vintage: 2020,
                region: "Margaret River, WA", country: "Australia",
                grape: "Cabernet Sauvignon", producer: "Vasse Felix",
                body: 4, tannin: 4, acidity: 3, sweetness: 1,
                flavours: ["blackcurrant", "cedar", "dark olive", "graphite", "bay leaf", "dark chocolate"],
                foodPairings: ["Beef tenderloin", "Lamb rack", "Aged cheddar", "Venison stew"],
                wineDescription: "Margaret River sits at the same latitude as Bordeaux, and wines like this show why. Structured and classical, with precise blackcurrant fruit, cedary oak and fine-grained tannins that will integrate beautifully over the next decade.",
                rating: 5, savedAt: date("2024-06-20T14:00:00.000Z"), source: .sample, isSaved: false
            ),
            // WHITES
            Wine(
                id: "sample-005",
                name: "Grosset Polish Hill Riesling",
                type: .white, vintage: 2023,
                region: "Clare Valley, SA", country: "Australia",
                grape: "Riesling", producer: "Grosset Wines",
                body: 2, tannin: 1, acidity: 5, sweetness: 1,
                flavours: ["lime zest", "green apple", "slate", "white blossom", "lemon curd", "crushed stone"],
                foodPairings: ["Fresh oysters", "Thai fish cakes", "Sashimi", "Vietnamese salads"],
                wineDescription: "Arguably Australia's most celebrated dry Riesling. Laser-sharp acidity from the high-altitude Polish Hill sub-region drives this to extraordinary length. Steely, mineral and precise, with citrus and slate in perfect balance. Drink now or cellar confidently for 15+ years.",
                rating: 5, savedAt: date("2024-02-14T11:00:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-006",
                name: "Henschke Louis Semillon Chardonnay",
                type: .white, vintage: 2022,
                region: "Eden Valley, SA", country: "Australia",
                grape: "Chardonnay", producer: "Henschke",
                body: 3, tannin: 1, acidity: 4, sweetness: 1,
                flavours: ["white peach", "nectarine", "toasted almond", "creamy lees", "grilled citrus", "flint"],
                foodPairings: ["Roast chicken", "Lobster bisque", "Grilled barramundi", "Soft-ripened brie"],
                wineDescription: "Eden Valley Chardonnay sits higher and cooler than the Barossa floor, delivering fruit-driven freshness with genuine complexity. Partial barrel fermentation adds texture and a toasty, nutty dimension, while bright acidity keeps everything vital and fresh on the finish.",
                rating: 4, savedAt: date("2024-03-28T16:30:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-007",
                name: "Shaw + Smith Sauvignon Blanc",
                type: .white, vintage: 2023,
                region: "Adelaide Hills, SA", country: "Australia",
                grape: "Sauvignon Blanc", producer: "Shaw + Smith",
                body: 2, tannin: 1, acidity: 4, sweetness: 1,
                flavours: ["passionfruit", "grapefruit", "freshly cut grass", "lychee", "gooseberry", "white nettle"],
                foodPairings: ["Grilled asparagus", "Goat's cheese salad", "Steamed mussels", "Herb-crusted snapper"],
                wineDescription: "The Adelaide Hills is Australia's answer to the Loire Valley — cool, maritime and fragrant. This Sauvignon Blanc is exuberant and aromatic, packed with tropical fruit and herbal lift, supported by crisp, refreshing acidity. The benchmark for Australian Sauvignon Blanc.",
                rating: 4, savedAt: date("2024-07-01T09:00:00.000Z"), source: .sample, isSaved: false
            ),
            // ROSÉS
            Wine(
                id: "sample-008",
                name: "Ten Minutes by Tractor Rosé",
                type: .rosé, vintage: 2023,
                region: "Mornington Peninsula, VIC", country: "Australia",
                grape: "Pinot Noir", producer: "Ten Minutes by Tractor",
                body: 2, tannin: 1, acidity: 4, sweetness: 1,
                flavours: ["wild strawberry", "watermelon", "rose petal", "blood orange", "stone fruit", "sea spray"],
                foodPairings: ["Fresh prawns", "Summer salads", "Grilled fish", "Antipasto"],
                wineDescription: "Pale salmon in colour, this Mornington Peninsula Rosé embodies the cool-climate character of the region. Made from Pinot Noir by direct press, it's delicate, finely structured and endlessly refreshing — a perfect warm-weather wine that never feels frivolous.",
                rating: 4, savedAt: date("2024-01-20T13:00:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-009",
                name: "Mac Forbes Rosé",
                type: .rosé, vintage: 2023,
                region: "Yarra Valley, VIC", country: "Australia",
                grape: "Pinot Noir", producer: "Mac Forbes",
                body: 2, tannin: 1, acidity: 4, sweetness: 1,
                flavours: ["cranberry", "red cherry", "dried flowers", "candied citrus", "white pepper"],
                foodPairings: ["Charcuterie", "Nicoise salad", "Grilled sardines", "Tuna tartare"],
                wineDescription: "A Provence-inspired Rosé made in the Yarra Valley by one of Australia's most thoughtful producers. Bone dry with a persistent mineral edge, this is a serious, food-driven wine in pale copper-pink. Complex and savoury — the kind of Rosé that converts sceptics.",
                rating: 3, savedAt: date("2024-02-28T10:00:00.000Z"), source: .sample, isSaved: false
            ),
            // SPARKLING
            Wine(
                id: "sample-010",
                name: "Jansz Premium Cuvée",
                type: .sparkling, vintage: 2020,
                region: "Pipers River, TAS", country: "Australia",
                grape: "Chardonnay, Pinot Noir", producer: "Jansz Tasmania",
                body: 2, tannin: 1, acidity: 4, sweetness: 2,
                flavours: ["green apple", "toasted brioche", "lemon curd", "almond", "white cherry", "chalk"],
                foodPairings: ["Oysters", "Smoked salmon blinis", "Soft cheeses", "Tempura prawns"],
                wineDescription: "Tasmania's cool climate is arguably the best environment in Australia for traditional-method sparkling wine. Jansz was among the first to recognise this potential. This non-vintage cuvée shows characteristic finesse — creamy mousse, bright acidity and a long, chalky finish.",
                rating: 4, savedAt: date("2024-05-22T18:00:00.000Z"), source: .sample, isSaved: false
            ),
            Wine(
                id: "sample-011",
                name: "BK Wines Pét-nat",
                type: .sparkling, vintage: 2023,
                region: "Adelaide Hills, SA", country: "Australia",
                grape: "Chardonnay", producer: "BK Wines",
                body: 1, tannin: 1, acidity: 5, sweetness: 2,
                flavours: ["green apple", "pear cider", "lemon sherbet", "chamomile", "fresh yeast", "honeydew"],
                foodPairings: ["Fried chicken", "Soft tacos", "Fresh spring rolls", "Creamy pasta"],
                wineDescription: "Pétillant naturel — the original method of sparkling winemaking. This Adelaide Hills Chardonnay is bottled before fermentation completes, creating gentle, natural bubbles. Cloudy and alive, with wild, yeasty character and zippy acidity that makes it genuinely thirst-quenching.",
                rating: 3, savedAt: date("2024-06-10T20:00:00.000Z"), source: .sample, isSaved: false
            ),
            // DESSERT
            Wine(
                id: "sample-012",
                name: "Chambers Rosewood Rutherglen Muscat",
                type: .dessert, vintage: 0,
                region: "Rutherglen, VIC", country: "Australia",
                grape: "Muscat Blanc à Petits Grains", producer: "Chambers Rosewood",
                body: 5, tannin: 1, acidity: 2, sweetness: 5,
                flavours: ["dark raisin", "toffee", "cold black tea", "dried orange peel", "roasted coffee", "Christmas pudding"],
                foodPairings: ["Vanilla ice cream", "Christmas cake", "Dark chocolate", "Sticky date pudding"],
                wineDescription: "Rutherglen Muscat is one of the world's great fortified wines — and Chambers Rosewood produces some of the finest examples. A blend of many vintages, aged through a solera-like system of old barrels. Extraordinarily complex, with layers of toffee, dried fruit and tea. A teaspoon of history in every glass.",
                rating: 5, savedAt: date("2024-07-05T21:00:00.000Z"), source: .sample, isSaved: false
            ),
        ]
    }

    // MARK: — Quiz Questions (12)
    static let quizQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "What does \"tannin\" primarily refer to in wine?",
            options: [
                "The sweetness level of the wine",
                "The sensation of dryness or grittiness on your gums and teeth",
                "The level of carbonation in sparkling wine",
                "The colour intensity of the wine",
            ],
            correctIndex: 1,
            explanation: "Tannins are polyphenols found mainly in grape skins, seeds and stems. They create a drying, grippy sensation — especially pronounced in red wines like Barossa Shiraz and Margaret River Cabernet."
        ),
        QuizQuestion(
            question: "Which of these describes high acidity in a wine?",
            options: [
                "A heavy, rich mouthfeel that coats the palate",
                "A mouth-watering, refreshing sensation similar to biting a lemon",
                "A dry, puckering sensation from tannins",
                "A warming sensation from high alcohol",
            ],
            correctIndex: 1,
            explanation: "Acidity makes wine feel lively and refreshing — it's the same sensation as fresh lemon juice. High-acid wines like Clare Valley Riesling and cool-climate Chardonnay pair beautifully with food because they cut through richness."
        ),
        QuizQuestion(
            question: "Which Australian region is most famous for old-vine Shiraz?",
            options: ["Yarra Valley", "Mornington Peninsula", "Barossa Valley", "Clare Valley"],
            correctIndex: 2,
            explanation: "The Barossa Valley in South Australia is home to some of the world's oldest Shiraz vines — many over 100 years old. The warm climate produces rich, concentrated wines with dark fruit, pepper and signature Barossa licorice."
        ),
        QuizQuestion(
            question: "What is the ideal serving temperature for a full-bodied red wine like Barossa Shiraz?",
            options: ["6–8°C (fridge cold)", "10–12°C", "16–18°C", "22–24°C (room temperature)"],
            correctIndex: 2,
            explanation: "Full-bodied reds are best served at 16–18°C — slightly below typical room temperature. Serving too warm makes alcohol more prominent and dulls the fruit. In summer, a brief 20 minutes in the fridge before serving helps."
        ),
        QuizQuestion(
            question: "Clare Valley and Eden Valley are best known for which white grape variety?",
            options: ["Chardonnay", "Sauvignon Blanc", "Riesling", "Viognier"],
            correctIndex: 2,
            explanation: "Clare Valley and Eden Valley are Australia's spiritual home of dry Riesling. The high altitude and cool nights preserve natural acidity, producing wines of extraordinary intensity and longevity — benchmark examples include Grosset and Henschke."
        ),
        QuizQuestion(
            question: "When matching wine with food, \"mirroring\" means:",
            options: [
                "Serving the same wine you used to cook the dish",
                "Choosing a wine that reflects similar flavours or weight to the food",
                "Always pairing red wine with red meat",
                "Matching the wine's vintage year to the occasion",
            ],
            correctIndex: 1,
            explanation: "Mirroring is one of three food pairing strategies. A rich, buttery Chardonnay mirrors the richness of a cream sauce; a light, bright Pinot Noir mirrors the delicacy of duck. The wine and dish share similar intensity and character."
        ),
        QuizQuestion(
            question: "What grape variety produces Pinot Noir?",
            options: [
                "Pinot Gris — a red-skinned mutation of Pinot Noir",
                "Pinot Noir is a red Vitis vinifera variety grown in cool climates",
                "Pinot Meunier — a relative of Pinot Noir used in Champagne",
                "Nebbiolo — an Italian variety often confused with Pinot Noir",
            ],
            correctIndex: 1,
            explanation: "Pinot Noir is a thin-skinned red grape variety that thrives in cool climates — Yarra Valley, Mornington Peninsula, Tasmania and Burgundy. Its delicate skins produce light-coloured wines with lower tannins but exceptional fragrance and complexity."
        ),
        QuizQuestion(
            question: "On a wine label, what does \"Reserve\" or \"Single Vineyard\" typically indicate?",
            options: [
                "The wine is only available at the cellar door",
                "The wine has been made from the producer's best parcels or barrels",
                "The wine must be consumed within one year of purchase",
                "The wine contains no added preservatives",
            ],
            correctIndex: 1,
            explanation: "Terms like \"Reserve\", \"Single Vineyard\" and \"Block\" signal the producer's top-tier wines — usually from outstanding fruit parcels or selected barrels. They're typically more concentrated, complex and expensive than entry-level offerings."
        ),
        QuizQuestion(
            question: "Which of the following is NOT a typical flavour descriptor for Chardonnay?",
            options: ["White peach and nectarine", "Toasted almond and cream", "Cracked black pepper and smoked meat", "Lemon curd and grilled citrus"],
            correctIndex: 2,
            explanation: "Cracked pepper and smoked meat are classic descriptors for cool-climate Shiraz, not Chardonnay. Chardonnay flavours range from citrus and green apple in cool climates to peach, mango and tropical fruit in warmer regions."
        ),
        QuizQuestion(
            question: "What is the primary difference between sparkling wine made by the Traditional Method vs. Pétillant Naturel?",
            options: [
                "Traditional Method uses CO₂ injection; Pét-nat uses natural fermentation",
                "Traditional Method completes fermentation in bottle; Pét-nat is bottled before fermentation finishes",
                "Traditional Method is always sweeter; Pét-nat is always dry",
                "Traditional Method uses Chardonnay only; Pét-nat uses any grape",
            ],
            correctIndex: 1,
            explanation: "In the Traditional Method (Méthode Champenoise), a second fermentation is triggered in bottle by adding sugar and yeast. Pétillant Naturel (\"pét-nat\") is simpler — the wine is bottled while the original fermentation is still underway, trapping natural CO₂."
        ),
        QuizQuestion(
            question: "Rutherglen Muscat is unique because:",
            options: [
                "It is Australia's only bone-dry fortified wine",
                "It is made from frozen grapes picked in winter",
                "It is a blended fortified wine aged through a solera-like system of old barrels",
                "It must be bottled within six months of harvest by law",
            ],
            correctIndex: 2,
            explanation: "Rutherglen Muscat is one of the world's great fortified wines, aged through successive vintages in a system of old barrels. The result is a complex, intensely sweet wine with flavours of toffee, raisin, dried orange and cold black tea — a true Australian original."
        ),
        QuizQuestion(
            question: "Why is McLaren Vale Grenache often described as a lighter-style red despite coming from a warm region?",
            options: [
                "Grenache grapes naturally have thick skins that block colour extraction",
                "The wines are blended with white Grenache to reduce colour and tannin",
                "Grenache has naturally thin skins, producing lighter colour and lower tannin even in warm climates",
                "McLaren Vale producers always ferment at very low temperatures to preserve delicacy",
            ],
            correctIndex: 2,
            explanation: "Grenache (Garnacha) has naturally thin skins relative to varieties like Shiraz or Cabernet. Even in warm McLaren Vale, this means lighter colour extraction and softer tannins. The best producers use old vines and minimal intervention to preserve fragrant, silky fruit."
        ),
    ]

    // MARK: — Learn Topics (9)
    static let learnTopics: [LearnTopic] = [
        LearnTopic(id: "tasting-basics", title: "The basics of tasting",           subtitle: "Sight, smell, taste — the full picture",        sfSymbol: "wineglass.fill",      category: .gettingStarted, readingTime: 5),
        LearnTopic(id: "wine-styles",    title: "Red, white, rosé and more",        subtitle: "How the main styles differ",                   sfSymbol: "list.bullet",         category: .gettingStarted, readingTime: 4),
        LearnTopic(id: "shiraz",         title: "Shiraz — Australia's signature red", subtitle: "From the Barossa to the world",              sfSymbol: "leaf.fill",           category: .grapes,         readingTime: 6),
        LearnTopic(id: "chardonnay",     title: "Chardonnay — oak and beyond",      subtitle: "Why it's the world's most popular white",      sfSymbol: "sparkles",            category: .grapes,         readingTime: 5),
        LearnTopic(id: "pinot-noir",     title: "Pinot noir — the heartbreaker",    subtitle: "Delicate but complex",                         sfSymbol: "heart.fill",          category: .grapes,         readingTime: 6),
        LearnTopic(id: "riesling",       title: "Riesling — Australia's best kept secret", subtitle: "Crisp, dry, world-class",               sfSymbol: "drop.fill",           category: .grapes,         readingTime: 5),
        LearnTopic(id: "barossa",        title: "Barossa Valley",                   subtitle: "Old vines, big reds, warm soul",               sfSymbol: "mountain.2.fill",     category: .regions,        readingTime: 4),
        LearnTopic(id: "food-pairing",   title: "Wine and food — the basics",       subtitle: "Match, mirror, contrast",                      sfSymbol: "fork.knife",          category: .pairing,        readingTime: 5),
        LearnTopic(id: "reading-labels", title: "Reading a wine label",             subtitle: "Decode what's in the bottle",                  sfSymbol: "tag.fill",            category: .gettingStarted, readingTime: 3),
    ]

    // MARK: — Articles (3 full articles)
    static let articles: [Article] = [
        Article(
            id: "tasting-basics",
            title: "The basics of tasting",
            readingTime: 5,
            intro: "Wine tasting sounds intimidating, but it's really a skill anyone can develop — and it starts with just paying attention. Professional tasters use a simple framework: look, smell, taste. By slowing down and working through each step consciously, you'll get far more from every glass.",
            sections: [
                ArticleSection(heading: "What you see", body: "Tilt the glass against a white background. The colour tells you a lot before you've even smelled anything. In reds, a deep purple-black suggests a young, full-bodied wine (think Barossa Shiraz); a brick-red or garnet edge signals age or a lighter variety like Pinot Noir. In whites, pale straw and green hints mean youth and high acidity; deep gold often means oak ageing or an older vintage. Clarity (cloudy vs. clear), brightness, and the viscosity of the wine as it runs down the glass (the \"legs\") all add to the picture."),
                ArticleSection(heading: "What you smell", body: "Swirling releases aromatic compounds — give the glass a good swirl, then put your nose right in and inhale. You're identifying fruit aromas (which ones? red fruit, citrus, tropical?), floral notes, and \"secondary\" aromas from winemaking like oak (vanilla, toast, coconut), yeast (bread, biscuit) or lees contact (cream, nuttiness). Don't worry if you can't name everything. Ask yourself: is it light and delicate, or intense and concentrated? Fruity or savoury? Fresh or complex? Start broad, then narrow down."),
                ArticleSection(heading: "What you taste", body: "Take a small sip and let it roll around your whole mouth — the different parts of your tongue detect sweetness, sourness (acidity) and saltiness. Your gums and inner cheeks feel tannin as a drying, grippy sensation. Notice the \"weight\" or body — does it feel light like water, medium like juice, or heavy like cream? Then there's the finish: how long do the flavours linger after you swallow? A long, persistent finish is a hallmark of quality."),
                ArticleSection(heading: "Structure vs flavour", body: "This is the key distinction most beginners miss. Flavour is what the wine tastes like — cherry, lemon, pepper, vanilla. Structure is how it feels — the tannin, acidity, body and alcohol. A wine can be low in flavour complexity but beautifully structured, or packed with fruit flavour but lacking in structure (often described as \"flabby\"). The best wines have both: compelling flavour and a skeleton of structure that holds it all together and gives it the ability to age."),
            ],
            facts: [
                ArticleFact(label: "Technique",     value: "WSET method"),
                ArticleFact(label: "Time to learn", value: "~5 minutes"),
                ArticleFact(label: "Skill level",   value: "Beginner"),
                ArticleFact(label: "Apply it",      value: "Any wine, any time"),
            ],
            quizIndices: [0, 1, 5]
        ),
        Article(
            id: "shiraz",
            title: "Shiraz — Australia's signature red",
            readingTime: 6,
            intro: "If Australia has a national grape variety, it's Shiraz. From the warm valley floors of the Barossa to the cool slopes of the Yarra and the rugged granite soils of Heathcote, no variety shows the breadth of Australian wine more compellingly — or produces more consistently thrilling results.",
            sections: [
                ArticleSection(heading: "Where it all started", body: "Shiraz arrived in Australia in the 1830s, planted by James Busby from cuttings sourced in France (where the same grape is called Syrah). It found its spiritual home in the Barossa Valley, where unphylloxerated soils — never devastated by the pest that destroyed European vineyards in the 1870s — preserved old vine material that dates back to the 1840s. These ancient vines, some over 150 years old, produce tiny quantities of intensely concentrated fruit. Penfolds Grange, first made in 1951, put Australian Shiraz on the world map."),
                ArticleSection(heading: "Barossa — the benchmark", body: "Barossa Shiraz is the quintessential Australian expression: rich, generous, full-bodied, with dark fruits (blackberry, plum, dark cherry), signature white pepper from rotundone compound, and the warmth of the valley floor imparting flavours of dark chocolate, coffee and licorice. Oak plays a key role — new American and French oak barrels add vanilla, spice and structure. Tannic but ripe, these wines can age magnificently for 20–40 years."),
                ArticleSection(heading: "Cool-climate Shiraz", body: "Push Shiraz into cooler areas — the Yarra Valley, Heathcote, McLaren Vale's higher elevations, or the Great Southern in WA — and the wine transforms. Colours lighten, tannins become finer, and savouriness takes over. Think blood orange, red cherry and violets rather than blackberry and chocolate. The peppery character becomes more prominent — sometimes intensely so — and the wine takes on a linear, almost Côte-Rôtie quality. This is Shiraz at its most elegant and food-friendly."),
                ArticleSection(heading: "Reading the label", body: "On Australian Shiraz labels, several things are worth noting. \"Estate grown\" means the grapes come from the winery's own vineyard — often a mark of quality. \"Old vines\" is unregulated (there's no minimum age requirement) but suggests lower yields and more concentration. Vintage matters enormously in the Barossa — 2010, 2012, 2014 and 2019 are considered exceptional vintages. Single-vineyard wines like Torbreck's The Laird or Henschke's Hill of Grace represent the pinnacle of estate expression — and the prices to match."),
            ],
            facts: [
                ArticleFact(label: "Best regions", value: "Barossa, Heathcote, Yarra"),
                ArticleFact(label: "Serve at",     value: "16–18°C"),
                ArticleFact(label: "Cellar",       value: "5–40 years"),
                ArticleFact(label: "Classic pair", value: "Slow-roasted lamb"),
            ],
            quizIndices: [2, 3, 8]
        ),
        Article(
            id: "food-pairing",
            title: "Wine and food — the basics",
            readingTime: 5,
            intro: "The idea that wine and food pairing is complicated — or that there are strict rules — is a myth. There are principles, not rules. Once you understand a few of them, you'll start making intuitive, successful pairings without needing a formula.",
            sections: [
                ArticleSection(heading: "The three strategies", body: "Every good pairing uses one of three approaches. Match: pair wines and dishes of similar intensity — a delicate Clare Valley Riesling with delicate steamed fish; a powerful Barossa Shiraz with a hearty slow-cooked lamb shoulder. Mirror: find flavour echoes — the citrus notes in a Sauvignon Blanc mirroring a lemon butter sauce; the earthiness of a Yarra Pinot Noir mirroring mushrooms. Contrast: find opposites that complement — the acidity of Champagne cutting through the fat of fried chicken; the sweetness of a dessert wine contrasting with sharp blue cheese."),
                ArticleSection(heading: "The weight principle", body: "This is the most reliable principle in food pairing. Match the weight (body) of the wine to the weight (richness) of the food. Light-bodied wines — Pinot Noir, Riesling, Rosé — work best with lighter dishes: seafood, salads, chicken, delicate pasta. Full-bodied wines — Barossa Shiraz, Margaret River Cabernet, aged Chardonnay — need equally substantial food: red meat, braised dishes, rich sauces and hard cheeses. When the match is wrong, one dominates and overwhelms the other."),
                ArticleSection(heading: "Acidity and fat", body: "High-acid wines are a cook's best friend at the table because acidity cuts through fat and richness, refreshing the palate between bites. This is why Champagne and Chablis work so beautifully with oysters; why a zippy Clare Valley Riesling transforms a rich piece of pan-fried barramundi; why Italian wines with their naturally high acidity are so well suited to olive-oil-based Mediterranean cooking. When in doubt with a rich dish, reach for something with acidity."),
                ArticleSection(heading: "Tannin and protein", body: "Tannin binds to protein and fat — which is why highly tannic reds like Cabernet Sauvignon taste harsh with fish (no fat to absorb the tannin) but magnificent with red meat (where protein and fat soften the tannin and make the wine taste rounder and more generous). A classic pairing like Margaret River Cabernet with aged beef works because the chemistry is perfect: fat tames the tannin, and the wine's acidity cuts through the richness of the meat. The same wine would taste astringent and metallic with grilled salmon."),
            ],
            facts: [
                ArticleFact(label: "Key principle",  value: "Match weight to weight"),
                ArticleFact(label: "Best shortcut",  value: "High acid = food-friendly"),
                ArticleFact(label: "Classic red pair", value: "Tannin + protein"),
                ArticleFact(label: "Experiment",     value: "Contrast surprises"),
            ],
            quizIndices: [5, 8, 3]
        ),
    ]
}
