// liff関連のlocalStorageのキーのリストを取得
const getLiffLocalStorageKeys = (prefix) => {
  const keys = []
  for (var i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i)
    if (key.indexOf(prefix) === 0) {
      keys.push(key)
    }
  }
  return keys
}
// 期限切れのIDTokenをクリアする
const clearExpiredIdToken = (liffId) => {
const keyPrefix = `LIFF_STORE:${liffId}:`
const key = keyPrefix + 'decodedIDToken'
const decodedIDTokenString = localStorage.getItem(key)
if (!decodedIDTokenString) {
  return
}
const decodedIDToken = JSON.parse(decodedIDTokenString)
// 有効期限をチェック
if (new Date().getTime() > decodedIDToken.exp * 1000) {
    const keys = getLiffLocalStorageKeys(keyPrefix)
    keys.forEach(function(key) {
      localStorage.removeItem(key)
    })
}
}

const main = async (liffId) => {
clearExpiredIdToken(liffId)
await liff.init({ liffId })
const idToken = liff.getIDToken()
// idTokenをサーバに投げるなどの処理...
}

// DOMが読み込まれたら処理が走る
document.addEventListener('DOMContentLoaded', () => {
  let data_id;
  
  clearExpiredIdToken(LIFF_ID);
  
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
        window.location = '/routines';
      });
    }
  }).catch((err) => {
    console.log(err);
  });
});
