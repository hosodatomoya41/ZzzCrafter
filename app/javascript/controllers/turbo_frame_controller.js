import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selector", "frame"];

  connect() {
    // 初期状態では何もしない
  }

  reload() {
    console.log("Selector Target:", this.selectorTarget);
    const selectedIssueType = this.selectorTarget.value;
    let newSrc = '';

    // ログ出力
    console.log("Selected Issue Type:", selectedIssueType);

    if (selectedIssueType === '') {
      // 選択が解除された場合、srcを空にする
      this.frameTarget.removeAttribute("src");
    } else {
      // 選択されたissue_typeに基づいてsrcを設定
      newSrc = `/users/recommend_routines?issue_type=${selectedIssueType}`;
      this.frameTarget.setAttribute("src", newSrc);
    }

    // ログ出力
    console.log("New Src:", newSrc);
  }
}
