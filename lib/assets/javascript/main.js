var frm = document.getElementById('frmDestroy');

if (frm) {
	frm.parentElement.addEventListener('submit', function(e) {
		e.preventDefault();
		confirmation = confirm("¿Realmente quieres eliminar tu cuenta?");

		if (confirmation)
			this.submit();
		else
			return false;
	});
}