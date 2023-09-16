/// 画像埋め込みされたQRコード生成
const qrCode = new QRCodeStyling({
  width: 250,
  height: 250,
  type: "canvas",
  data: "https://hogehoge.com",
  qrOptions: {
    errorCorrectionLevel: 'H'
  },
  dotsOptions: {
    color: "#4267b2",
    type: "square"
  },
  cornersSquareOptions:{
    type: "square"
  },
  cornersDotOptions: {
    type: "square"
  },
  backgroundOptions: {
    color: "#fff",
  },
  imageOptions: {
    crossOrigin: "anonymous",
    margin: 0,
  }
});

/// 要素に生成されたQRコードを表示
const $qrCode = document.getElementById('qrCode');
qrCode.append($qrCode);