document.addEventListener("DOMContentLoaded", function() {
  const $qrCodeElement = document.getElementById('qrCode');
  
  const lineId = "@112nzsun";
  const lineText = $qrCodeElement.getAttribute('data-line-text'); 

  const encodedLineId = encodeURIComponent(lineId);
  const encodedLineText = encodeURIComponent(lineText);

/// 画像埋め込みされたQRコード生成
const qrCode = new QRCodeStyling({
  width: 250,
  height: 250,
  type: "canvas",
  data: `https://line.me/R/oaMessage/${encodedLineId}/?${encodedLineText}`,
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
qrCode.append($qrCodeElement);
});