<?php
/**
 *    Copyright (C) 2018 Damien Vargas
 *    Copyright (C) 2017 Frank Wall
 *    Copyright (C) 2015 Deciso B.V.
 *
 *    All rights reserved.
 *
 *    Redistribution and use in source and binary forms, with or without
 *    modification, are permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *    THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 *    AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *    AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 *    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *    POSSIBILITY OF SUCH DAMAGE.
 *
 */
namespace OPNsense\OpnProxy;

use OPNsense\Base\BaseModel;
use OPNsense\Core\Backend;


/**
 * Class OpnProxy
 * @package OPNsense\OpnProxy
 */
class ProxyDef extends GlobalModel
{
	private $opnproxy_conf='/usr/local/opnsense/service/conf/configd.conf';
	private $flag_replaced=false;

    /**
     * check if module is enabled
     * @return bool is the OpnProxy service enabled
     */
    public function isEnabled()
    {
        if ((string)$this->enabled === "1") {
            return true;
        }
        return false;
    }
    
    private function create_config(){
    	
    }
    
    private function addProxyData(&$fileData){
    	$this->removeProxyData($fileData);
    	if(!empty((string)$this->httpProxyIP) && !empty((string)$this->httpProxyPort)){
    		$fileData[].= "HTTP_PROXY=".(string)$this->proxyType."://".(string)$this->httpProxyIP.":".(string)$this->httpProxyPort."\n";
    		$fileData[].= "http_proxy=".(string)$this->proxyType."://".(string)$this->httpProxyIP.":".(string)$this->httpProxyPort."\n";
    	}
    	if(!empty((string)$this->httpsProxyIP) && !empty((string)$this->httpsProxyPort)){
    		$fileData[].= "HTTPS_PROXY=".(string)$this->proxyType."://".(string)$this->httpsProxyIP.":".(string)$this->httpsProxyPort."\n";
    		$fileData[].= "https_proxy=".(string)$this->proxyType."://".(string)$this->httpsProxyIP.":".(string)$this->httpsProxyPort."\n";
    	}
    	if(!empty((string)$this->ftpProxyIP) && !empty((string)$this->ftpProxyPort)){
    		$fileData[].= "FTP_PROXY=".(string)$this->proxyType."://".(string)$this->ftpProxyIP.":".(string)$this->ftpProxyPort."\n";
    		$fileData[].= "ftp_proxy=".(string)$this->proxyType."://".(string)$this->ftpProxyIP.":".(string)$this->ftpProxyPort."\n";
    	}
    	return $this;    	
    }
    
    private function removeProxyData(&$fileData){
    	foreach($fileData as $pos=>$lineOfData){
    		if(stripos($lineOfData,"_PROXY")!==false){
    			unset($fileData[$pos]);
    		}
    	}
    	return $this;
    }
    
    public function generateOpnproxyConf() {
    	$Data=file($this->opnproxy_conf);
    	if(! $this->isEnabled()){
    		$this->removeProxyData($Data);
    	} else {    	
    		$this->addProxyData($Data);
    	}
    	
    	exec ( "/bin/mv -f " . $this->opnproxy_conf . " " . $this->opnproxy_conf . "_sav" );
    	file_put_contents ( $this->opnproxy_conf, $Data );

    	return $this;
    }
    
}
