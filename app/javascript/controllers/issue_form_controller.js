// issue_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selector"];
  isSubmitted = false;  // 二重送信を防ぐフラグを追加

  submitForm(event) {
    event.preventDefault();
    console.log("issueFormTarget:", this.selectorTarget);

    
    if (!this.selectorTarget) { 
      console.error("selectorTarget is undefined");
      return;
    }

    // 二重送信を防ぐ
    if (this.isSubmitted) {
      return;
    }
    this.isSubmitted = true;

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
      const parser = new DOMParser();
      const doc = parser.parseFromString(html, "text/html");
      const content = doc.querySelector("#issue_content");
      
      const turboFrame = document.getElementById("issue_content");
      if (turboFrame && content) {
        turboFrame.innerHTML = content.innerHTML;
      }
      else {
        console.error("turboFrame or content is not found");
        return;
      }
    })
    .finally(() => {
      this.isSubmitted = false;  // リクエストが完了したらフラグをリセット
    });
  }
}
