Routine.delete_all
routines = [
  { name: "瞑想", description: "腹式呼吸を意識して瞑想をしましょう。寝ながらでも大丈夫です。最初は5分間を目標に、徐々に時間を伸ばしていってみましょう。", line_text: "そのまま送信してください。\n[瞑想]を追加しました", recommend_time: :before0 },
  { name: "ストレッチ", line_text: "そのまま送信してください。\n[ストレッチ]を追加しました", recommend_time: :before0, description:
  "寝る前のストレッチをしましょう。20~30秒、体を伸ばすだけで心身の緊張がほぐれ、寝付きがよくなります。" },
  { name: "アロマを焚く", description: "ラベンダー、スイートオレンジ、カモミール等はリラックス系のアロマで、安眠へ導く効果が期待できると言われています。", line_text: "そのまま送信してください。\n[アロマを焚く]を追加しました", recommend_time: :before0 },
  { name: "日記を書く", description: "不満や明日やること等、考えをノートに書き出しましょう。続けることでネガティブ感情やストレスが整理されてリラックスできます。", line_text: "そのまま送信してください。\n[日記を書く]を追加しました。", recommend_time: :before1 },
  # { name: "入浴", description: "１時間前から入浴(シャワーを浴びる)することにより、寝るタイミングで体温が下がり始めて眠りにつきやすくなります。", line_text: "そのまま送信してください。\n[シャワーを浴びる]を追加しました", recommend_time: :before1 },
  { name: "読書", description: "積んでている本がありますね？この機会に読書をしましょう！", line_text: "そのまま送信してください。\n[読書]を追加しました", recommend_time: :before1 },
  { name: "デジタル・デトックス", description: "ブルーライトを浴びないように気をつけましょう。現代人にとっては一番難しいかもしれません。しかし、効果は高いです。スマホやパソコンを物理的に遠くへ置いておくのもおすすめです。", line_text: "そのまま送信してください。\n[デジタル・デトックス]を追加しました", recommend_time: :before1 },
  { name: "有酸素運動", description: "運動習慣がある人には不眠が少ないと言われています。ジョギングやウォーキングなど適度な有酸素運動を行うことにより、睡眠ホルモンのメラトニンの材料となるセロトニンの分泌が増え、寝る頃にはメラトニンがしっかり分泌されて、安眠へと繋がります。", line_text: "そのまま送信してください。\n[運動]を追加しました", recommend_time: :before3 },
  { name: "パワーナップ", description: "日中とんでもなく眠いとき、コーヒーを一杯なるべく早いペースで飲んでから10分ほど昼寝をすると、ちょうど目覚めたタイミングでカフェインの効果が効き始め、眠気が覚める効果があります。その結果、変な時間帯に眠ってしまう可能性は減るでしょう。", line_text: "そのまま送信してください。\n[パワーナップ]を追加しました", recommend_time: :before10 },
  { name: "夕飯を食べる", description: "食べ物の消化には2〜3時間かかると言われており、夕飯は就寝の3時間以上前に済ませておくと胃腸への負担が軽減されて安眠へと繋がります。", line_text: "そのまま送信してください。\n[夕飯を済ませる]を追加しました", recommend_time: :before3 }
]

routines.each do |routine|
  Routine.create(routine)
end
