# Get Ingress Egress Bandwidth Usage for an NSX-T Tier-1 Gateway

## Description

This script use the [PowervRNI](https://github.com/PowervRNI/powervrni) PowerShell module to get **ingress and egress bandwidth statistics for an NSX-T Tier-1 Gateway** (on-premises, or VMConAWS). The output of the script can be useful to calculate egress traffic charges for public clouds (e.g.,in a VMware Cloud on AWS context) by Tier-1 Gateways.

Starting vRealize Network Insight (vRNI) 3.6, the platform has a public API. PowervRNI is a PowerShell module that takes advantage of those public APIs and provides you with the option to look at vRNI data using PowerShell.

> Note: this script is provided as an example.

## Usage

The following steps assumes that vRealize Network Insight (or vRealize Network Insight Cloud) is already deployed, configured, and collecting data from vCenter and relevant NSX-T Manager.

### Install PowervRNI

The easiest way is to install PowervRNI is through the **PowerShell Gallery** where everything is taken care of for you.

```powershell
PS C:\> Install-Module PowervRNI
PS C:\> Import-Module PowervRNI
```

### Connection to vRNI

The API of vRNI requires you to login to the Platform VM first. Here's how:

```powershell
PS C:\> Connect-vRNIServer -Server superdope.vrni.lab -Username admin@local -Password VMware1!
```

### Give me the bandwidth

* Adapt the list of NSX-T Edge Gateway (`$Tier1Gateways_to_lookup`, [line 29](https://github.com/cloudmaniac/powershell-nsxt-tier1-bandwidth-vrni/blob/ac3ca0bccbf1ea612b2048a5a4e788d1e85dc940/get-tier1-stats.ps1#L29)) to your environment
* Launch the script
* Enjoy

<img width="1115" alt="Get the NSX-T Tier-1 Gateways Ingress and Egress Bandiwdth Statistics with PowervRNI" src="https://user-images.githubusercontent.com/10382023/105517258-1aa9ed00-5cd7-11eb-98d5-17eefdd95701.png">

## Considerations

> The period is currently 24 hours.

## Enhancements

* Move the variable from static definition in the code to input
* Provide time frame choice (by 24 hours, monthly, etc.)
