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

    form.submit(); // フォームを送信
  }
}
