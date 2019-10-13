<?php

/**
 *    Copyright (C) 2018 Damien Vargas
 *    Copyright (C) 2017 Frank Wall
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
 */

function opnproxy_enabled()
{
    global $config;

    return isset($config['OPNsense']['opnproxy']['enabled']) &&
    $config['OPNsense']['opnproxy']['enabled'] == 1;
}

function opnproxy_configure()
{
	return array(
			'earlybootup' => array('opnproxy_configure_do'),
	);
}

function opnproxy_configure_do($verbose = false)
{
	$res = configd_run('opnproxy configure');
	
	if ($verbose) {
		
		printf("OpnProxy configure: %s\n", trim($res));
		
	}
	return;
}

function opnproxy_reconfigure_do($verbose = false, $interface ='')
{
	$res = configd_run('opnproxy reconfigure');
	
	if ($verbose) {
		
		printf("OpnProxy reconfigure: %s for %s\n", trim($res),$interface);
		
	}
	return;
}

/**
 *  sync configuration via xmlrpc
 * @return array
 */

function opnproxy_xmlrpc_sync()
{
    $result = array();
    $result['id'] = 'opnproxy';
    $result['section'] = 'OPNsense.opnproxy';
    $result['description'] = gettext('Sync OpnProxy tool');
    return array($result);
}
