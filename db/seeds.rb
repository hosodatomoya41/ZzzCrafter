Routine.delete_all
routines = [
  { name: "瞑想", description: "5分間瞑想をします", line_text: "瞑想を追加しました", recommend_time: :before0 },
  { name: "ストレッチ", description: "寝る前のストレッチ", recommend_time: :before0 },
  { name: "アロマを焚く", description: "ラベンダー、バラ、オレンジ、ピーチ等の香りを嗅ぐと悪夢を見る確率が減少すると言われている。", recommend_time: :before0 },
  { name: "日記を書く", description: "不満や明日やること等、考えを書き出す。4日以上続けることでネガティブ感情やストレスが整理されてリラックスできます。", recommend_time: :before1 },
  { name: "入浴", description: "１時間半前から入浴(シャワーを浴びる)することにより、寝るタイミングで体温が下がり始めて眠りにつきやすい", recommend_time: :before1 },
  { name: "読書", description: "読書をする", recommend_time: :before1 },
  { name: "デジタル・デトックス", description: "ブルーライトを浴びないようにする", recommend_time: :before1 },
  { name: "有酸素運動", description: "ジョギングやウォーキングなど、適度な有酸素運動をする", recommend_time: :before3 },
  { name: "パワーナップ", description: "コーヒーを一杯飲んでから10分ほど昼寝をすると、アラ不思議！目が覚めます！", recommend_time: :before3 },
  { name: "夕飯を食べる", description: "食べ物の消化には2〜3時間かかると言われており、夕飯は就寝の3時間以上前に済ませておくと胃腸への負担が軽減されて眠りにつきやすくなります。", recommend_time: :before3 }
]

routines.each do |routine|
  Routine.create(routine)
end
