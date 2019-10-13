{#
 # Copyright (C) 2018 Damien Vargas
 # Copyright (C) 2017 Frank Wall
 # Copyright (C) 2014-2015 Deciso B.V.
 # All rights reserved.
 #
 # Redistribution and use in source and binary forms, with or without modification,
 # are permitted provided that the following conditions are met:
 #
 # 1.  Redistributions of source code must retain the above copyright notice,
 #     this list of conditions and the following disclaimer.
 #
 # 2.  Redistributions in binary form must reproduce the above copyright notice,
 #     this list of conditions and the following disclaimer in the documentation
 #     and/or other materials provided with the distribution.
 #
 # THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 # AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 # AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 # OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 # SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 # INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 # CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 # ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 # POSSIBILITY OF SUCH DAMAGE.
 #}

<script>
    $( document ).ready(function () {
        var data_get_map = {'frm_proxydef_settings':"/api/opnproxy/proxydef/get"};
        mapDataToFormUI(data_get_map).done(function (data) {
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
            updateServiceControlUI('opnproxy');
            isSubsystemDirty();
        });

        // link save button to API set action
        $("#saveAct").click(function () {
            saveFormToEndpoint(url="/api/opnproxy/proxydef/set", formid='frm_proxydef_settings',callback_ok=function () {
            });
            isSubsystemDirty();
        });
        
      /**
       * get the isSubsystemDirty value and print a notice
       */
      function isSubsystemDirty() {
         ajaxGet(url="/api/opnproxy/service/dirty", sendData={}, callback=function(data,status) {
            if (status == "success") {
               if (data.opnproxy.dirty === true) {
                  $("#configChangedMsg").removeClass("hidden");
               } else {
                  $("#configChangedMsg").addClass("hidden");
               }
            }
         });
      }

        /*************************************************************************************************************
         * Commands
         *************************************************************************************************************/

        /**
         * Reconfigure
         */
        $("#btnApplyConfig").unbind('click').click(function(){
            $("#btnApplyConfigProgress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/opnproxy/service/reconfigure", sendData={}, callback=function(data,status) {
                if (status != "success" || data['status'] != 'ok') {
                    BootstrapDialog.show({
                        type: BootstrapDialog.TYPE_WARNING,
                        title: "{{ lang._('Error reconfiguring OpnProxy') }}",
                        message: data['status'],
                        draggable: true
                    });
                    //On stoppe le pulse
                    $("#btnApplyConfigProgress").removeClass("fa fa-spinner fa-pulse");
                } else {
                	//On stoppe le pulse
                	$("#btnApplyConfigProgress").removeClass("fa fa-spinner fa-pulse");
                	//On cache le bouton
                	$('#btnApplyConfig').blur();
                	//On valide le nettoyage
                	isSubsystemDirty();
                }
            });
        });
        
        // update history on tab state and implement navigation
    	if(window.location.hash != "") {
        	$('a[href="' + window.location.hash + '"]').click()
    	}
    	$('.nav-tabs a').on('shown.bs.tab', function (e) {
        	history.pushState(null, null, e.target.hash);
    	});
    });
</script>

<div class="alert alert-info hidden" role="alert" id="configChangedMsg">
   <button class="btn btn-primary pull-right" id="btnApplyConfig" type="button"><b>{{ lang._('Apply changes') }}</b> <i id="btnApplyConfigProgress"></i></button>
   {{ lang._('The OpnProxy configuration has been changed') }} <br /> {{ lang._('You must apply the changes in order for them to take effect.')}}
</div>

<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#proxydef">{{ lang._('Main Settings') }}</a></li>
</ul>
<div class="tab-content content-box tab-content">
    <div id="proxydef" class="tab-pane fade in active">
        <div class="content-box" style="padding-bottom: 1.5em;">
            {{ partial("layout_partials/base_form",['fields':proxydefForm,'id':'frm_proxydef_settings'])}}
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
            </div>
        </div>
    </div>
</div>

