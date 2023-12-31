# frozen_string_literal: true

routines = [
  { name: '瞑想', description: "腹式呼吸を意識して瞑想をしましょう。\n寝ながらでも問題ありません。\n最初は5分間を目標に、徐々に時間を伸ばしていってみましょう。",
    line_text: "そのまま送信してください。\n[瞑想]を追加しました", recommend_time: :before0 },
  { name: 'ストレッチ', line_text: "そのまま送信してください。\n[ストレッチ]を追加しました", recommend_time: :before0, description:
  "寝る前のストレッチをしましょう。\n体を伸ばすだけで心身の緊張がほぐれ、寝付きがよくなる効果が期待できます。" },
  { name: 'アロマ',
    description: "ラベンダー、スイートオレンジ、カモミール等はリラックス系のアロマで、安眠へ導く効果が期待できると言われています。\nお気に入りの香りのアロマを探してみるのはいかがでしょうか。", line_text: "そのまま送信してください。\n[アロマを焚く]を追加しました", recommend_time: :before0 },
  { name: '音楽鑑賞', line_text: "そのまま送信してください。\n[音楽鑑賞]を追加しました。", recommend_time: :before0, description:
  "リラックス効果があるクラシックや自然音が入った音楽を聞くのがおすすめです。\n激しい音楽や、歌詞がある音楽は意識が音楽に向いてしまうので非推奨です。" },
  { name: '日記', description: "不満や明日やること等、考えを何でもいいのでノートに書き出しましょう。\n続けることでネガティブ感情やストレスが整理されてリラックスでき、アウトプットにもなります。",
    line_text: "そのまま送信してください。\n[日記を書く]を追加しました。", recommend_time: :before1 },
  { name: '入浴',
    description: '１時間前から入浴することにより、寝る時に体温が下がり始めて眠りにつきやすくなります。湯船の温度は39度〜40度あたりのぬるま湯で、20〜30分ほど浸かるのがオススメです！', line_text: "そのまま送信してください。\n[入浴]を追加しました", recommend_time: :before1 },
  { name: '読書', description: "買ったはいいけどあまり読む機会がなかった本、この機会に読んでみるのもいいかもしれません！\n紙の本ならデジタル・デトックスの効果もあります。",
    line_text: "そのまま送信してください。\n[読書]を追加しました", recommend_time: :before1 },
  { name: 'ホットドリンク', line_text: "そのまま送信してください。\n[ホットドリンクを飲む]を追加しました", recommend_time: :before1, description:
  "温かい飲み物を飲むと、体温が一時的に上がり、その後体温が下がっていくタイミングで眠気を促す効果があります。\nホットミルクや、白湯がおすすめです。" },
  { name: '部屋の明かりを暗くする', line_text: "そのまま送信してください。\n[部屋の明かりを暗くする]を追加しました。", recommend_time: :before1, description:
  "寝る1時間前からは、部屋の明るさを抑えるようにしましょう。\n暗い環境はメラトニンの分泌を促し、眠りにつきやすくなります。" },
  { name: 'デジタル・デトックス',
    description: "夜間にブルーライトを浴びると、睡眠ホルモンと言われているメラトニンの分泌が抑制され、寝付きの悪さに繋がります。\n就寝前はブルーライトを浴びることを避けましょう。", line_text: "そのまま送信してください。\n[デジタル・デトックス]を追加しました", recommend_time: :before1 },
  { name: '運動',
    description: 'ジョギングや筋トレなど適度な運動を行うことにより、睡眠ホルモンのメラトニンの材料となるセロトニンの分泌が増え、安眠へと繋がります。', line_text: "そのまま送信してください。\n[運動]を追加しました", recommend_time: :before3 },
  { name: 'パワーナップ',
    description: "昼寝を沢山してしまう人におすすめです。コーヒー一杯を早いペースで飲んでから10分ほど昼寝をしてみましょう。\n目覚めたタイミングでカフェインが効き始め、眠気が覚めます。", line_text: "そのまま送信してください。\n[パワーナップ]を追加しました", recommend_time: :before10 },
  { name: '夕飯', description: "食べ物の消化には2〜3時間かかると言われています。\n夕飯は就寝の3時間以上前に済ませておくと胃腸への負担が軽減されて安眠へと繋がります。",
    line_text: "そのまま送信してください。\n[夕飯を済ませる]を追加しました", recommend_time: :before3 },
  { name: '家事、整理整頓', line_text: "そのまま送信してください。\n[家事、整理整頓]を追加しました", recommend_time: :before3, description:
  "家事や整理整頓をすることで、心地よい環境を作り出し、リラックスと安心感につながります。\nまた、身体を軽く動かすことで、適度な疲れを感じやすくなります。" }
]

sleep_issues = [
  { issue_type: 'night_life' },
  { issue_type: 'late_falling_asleep' },
  { issue_type: 'waking_up_in_the_middle' }
]

routines.each do |routine|
  record = Routine.find_or_initialize_by(name: routine[:name])
  record.update!(routine)
end

sleep_issues.each do |issue|
  SleepIssue.find_or_create_by!(issue)
end

issue_routine_mappings = {
  night_life: [1, 3, 5, 8, 11, 12],
  late_falling_asleep: [1, 4, 8, 10, 11, 14],
  waking_up_in_the_middle: [2, 3, 9, 10, 11, 14]
}

issue_routine_mappings.each do |issue_type, routine_ids|
  sleep_issue = SleepIssue.find_by(issue_type: issue_type)
  routine_ids.each do |routine_id|
    routine = Routine.find(routine_id)
    sleep_issue.routines << routine unless sleep_issue.routines.include?(routine)
  end
end
