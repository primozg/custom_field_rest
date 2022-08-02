function observeRestField(fieldId, url, options) {
    $(document).ready(function() {
		
           var url_obj = {
                    url: url,
                    dataType: "json",
                    success: function(data) {
                    $('#'+fieldId).empty();
      for (var i=0;i<data.length;i++){
      var o = new Option(data[i],data[i]);
         $(o).html(data[i]);
         $('#'+fieldId).append(o);
      }
      
                    }
                }
                $.ajax(url_obj);

    });
}
