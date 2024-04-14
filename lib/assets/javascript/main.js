// frmDestroyというIDを持つHTML要素を取得し、変数frmに格納します。
var frm = document.getElementById('frmDestroy');

// frmが存在する場合にのみ、以下の処理を実行します。
if (frm) {
	// frmの親要素に対して、submitイベントリスナーを追加します。
	frm.parentElement.addEventListener('submit', function(e) {
		// デフォルトのフォーム送信を一時停止します。
		e.preventDefault();
		// ユーザーに確認のダイアログを表示します。「本当にアカウントを削除しますか？」
		confirmation = confirm("¿Realmente quieres eliminar tu cuenta?");

		// ユーザーがOKをクリックした場合、フォームを送信します。
		if (confirmation)
			this.submit();
		else
			// ユーザーがキャンセルをクリックした場合、何もせずに戻ります。
			return false;
	});
}