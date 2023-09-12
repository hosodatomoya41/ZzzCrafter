// DOMが読み込まれたら処理が走る
document.addEventListener('DOMContentLoaded', () => {
  console.log('button input');
  // LIFFの初期化
  liff.init({ liffId: LIFF_ID }).then(() => {
    const railsLogoutButton = document.getElementById('logout-button');
    console.log(document.getElementById('logout-button'));

    railsLogoutButton.addEventListener('click', () => {
      if (liff.isLoggedIn()) {
        console.log('logout success');
        liff.logout();
        window.location.href = '/logout'; // ログアウトURLに遷移
      }
    });
  }).catch((err) => {
    console.error('LIFF Initialization failed ', err);
  });
}); // この閉じカッコが足りなかった
