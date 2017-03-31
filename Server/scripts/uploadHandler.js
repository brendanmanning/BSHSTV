function fileOnChange() {
  document.forms['upload_form'].submit();
  document.getElementById("goBack").hidden = true;
  document.getElementById("title").innerHTML = "Uploading...";
  document.getElementById("upload_form").hidden = true;
  document.getElementById("reason").innerHTML = "Please do <strong>not</strong> close this tab";
}
