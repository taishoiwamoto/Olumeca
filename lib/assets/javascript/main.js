var frm = document.getElementById('frmDestroy');

if (frm) {
	frm.parentElement.addEventListener('submit', function(e) {
		e.preventDefault();
		confirm("¿Realmente quieres eliminar tu cuenta?") ? this.submit : return false;

		if (confirmation)
			this.submit();
		else
			return false;
	});
}