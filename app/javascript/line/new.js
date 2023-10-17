document.addEventListener('DOMContentLoaded', () => {
  if (window.location.pathname === '/users/new') {

  let data_id;
  
  // csrf-tokenを取得
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  
  // LIFF_IDを使ってLIFFの初期化
  liff.init({
    liffId: LIFF_ID,
    // 他のブラウザで開いたときは初期化と一緒にログインもさせるオプション
    withLoginOnExternalBrowser: true
  }).then(() => {
    if (!liff.isLoggedIn()) {
      // ログインしていない場合、ログイン画面に遷移
      liff.login();
    } else {
      // ログインしている場合、IdTokenを取得
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
      // jsonでレスポンスからデータを取得して/...に遷移する
      .then(response => {
        console.log(response);
        return response.json();
      })
      .then(data => {
        data_id = data;
      })
      .then(() => {
        window.location = '/';
      });
    }
  }).catch((err) => {
    console.log(err);
  });

}
});
