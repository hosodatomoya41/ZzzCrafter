// DOMが読み込まれたら処理が走る
document.addEventListener('DOMContentLoaded', () => {
  console.log("Turbo:load event fired");
  // csrf-tokenを取得
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  // LIFF_IDを使ってLIFFの初期化
  liff.init({
    liffId: LIFF_ID,
    // 他のブラウザで開いたときは初期化と一緒にログインもさせるオプション
    withLoginOnExternalBrowser: true
  }).then(() => {
    // 初期化によって取得できるidtokenの定義
    const idToken = liff.getIDToken();
    // bodyにパラメーターの設定
    const body = `idToken=${idToken}`;
    // リクエスト内容の定義
    const request = new Request('/users', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'X-CSRF-Token': token
      },
      method: 'POST',
      body: body
    });

    // リクエストを送る
    fetch(request)
    // jsonでレスポンスからデータを取得して/static_pagesに遷移する
    .then(response => response.json())
    .then(data => {
      data_id = data;
    })
    .then(() => {
      window.location = '/';
    });
  });
});
