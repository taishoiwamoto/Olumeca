/*
document.addEventListener('contextmenu', function(e) {
	e.preventDefault();
});

document.addEventListener('keydown', function(e) {
	if(parseInt(e.keyCode) == 123) {
		e.preventDefault();
	}
});
*/

var frm = document.getElementById('frmDestroy');

if (frm) {
	frm.parentElement.addEventListener('submit', function(e) {
		e.preventDefault();
		return conf = confirm('¿Realmente quieres eliminar tu cuenta?') ? this.submit() : false;
	})
}
