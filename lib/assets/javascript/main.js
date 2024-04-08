// このJavaScriptコードは、特定のIDを持つフォーム（frmDestroy）に対して、
// フォームの送信を試みる前にユーザーに削除の確認を求める機能を追加します。
// 具体的には、ユーザーがアカウント削除フォームを送信しようとする際に、確認ダイアログを表示し、
// ユーザーがその操作を確認した場合のみフォームが送信されるようになります。操作が確認されなかった場合は、フォームの送信がキャンセルされます。

// 特定のID('frmDestroy')を持つフォーム要素を取得する
var frm = document.getElementById('frmDestroy');

// 取得したフォーム要素が実際に存在するかを確認
if (frm) {
	// フォーム要素の親要素に対して、'submit'イベントリスナーを追加
	frm.parentElement.addEventListener('submit', function(e) {
		// イベントのデフォルトの動作（ここではフォームの送信）をキャンセル
		e.preventDefault();
		// 確認ダイアログを表示し、ユーザーが'OK'をクリックした場合のみ次の処理を実行
		confirmation = confirm("¿Realmente quieres eliminar tu cuenta?");

		// ユーザーが'OK'をクリックした場合、フォームを送信
		if (confirmation)
			// フォームをサブミット
			this.submit();
		else
			// フォームのサブミットをキャンセル
			return false;
	});
}