#!/usr/bin/env python


import subprocess
from xml.dom import minidom

def get_virsh_cap():
    p = subprocess.Popen(["virsh", "capabilities"], stdout=subprocess.PIPE)
    out, err = p.communicate()
    return out

def getText(nodelist):
    rc = []
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data)
    return ''.join(rc)

def parse_cpu_model(cap_xml):
    xmldoc = minidom.parseString(cap_xml)
    capabilities = xmldoc.getElementsByTagName('capabilities')
    hosts = capabilities[0].getElementsByTagName("host")
    cpus = hosts[0].getElementsByTagName("cpu")
    cpu_models = cpus[0].getElementsByTagName("model")
    return cpu_models[0].firstChild.data


if __name__ == "__main__":
    cap_xml = get_virsh_cap()
    cpu_model = parse_cpu_model(cap_xml)
    print cpu_model
