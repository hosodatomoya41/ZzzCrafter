// メッセージを送信する関数
async function sendMessage() {
  const message = "ボタンをクリックしました";  // この行を変更

  // 以降は前のコードと同じ
  if (liff.isInClient()) {
    try {
      await liff.sendMessages([
        {
          type: 'text',
          text: message,  // この行も変更することで特定のメッセージが設定されます
        },
      ]);
      liff.closeWindow();
    } catch (error) {
      console.error('Failed to send message', error);
    }
  } else {
    try {
      await fetch('/send_line_message', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ line_user_id: line_user_id, message: message }), // この行も変更することで特定のメッセージが設定されます
      });
      alert('メッセージを送信しました');
    } catch (error) {
      console.error('Failed to send message', error);
    }
  }
}
window.sendMessage = sendMessage; // HTMLからも呼び出せるようにする
