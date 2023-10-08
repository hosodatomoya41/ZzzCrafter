// issue_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selector"];

  submitForm(event) {
    event.preventDefault();
    const selectedIssueType = this.selectorTarget.value;
    const form = document.getElementById('issue_form');

    // 選択されたissue_typeをhiddenフィールドにセット
    const hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'issue_type');
    hiddenInput.setAttribute('value', selectedIssueType);
    form.appendChild(hiddenInput);

    // 非同期通信でフォームを送信
    fetch(form.action, {
      method: form.method,
      body: new FormData(form),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',  // RailsがAjaxリクエストとして認識するために必要
      },
    })
    .then(response => response.text())
    .then(html => {
      // Turboフレームの内容を更新
      const turboFrame = document.getElementById("issue_content");
      if (turboFrame) {
        turboFrame.innerHTML = html;
      }
    });
  }
}
