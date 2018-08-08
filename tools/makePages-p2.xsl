<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<xsl:output method="text" indent="yes"/>

<xsl:variable name="datadir" select="'../Data/NISP/data/pages/Main'" />


<xsl:template match="standards">
<!--
  <xsl:apply-templates select="organisations"/>
  <xsl:apply-templates select="taxonomy"/>
  <xsl:apply-templates select="records/standard"/>
-->
</xsl:template>


<!-- Create a Wiki page for each organisation -->

<xsl:template match="organisations">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="orgkey">
<xsl:variable name="uc-key" select="upper-case(@key)"/>
<xsl:result-document href="{$datadir}/{$uc-key}.page">
<xsl:text>{{Organization&#x0A;</xsl:text>
<xsl:text>|acronym=</xsl:text><xsl:value-of select="upper-case(@key)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:value-of select="@long"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|website=</xsl:text><xsl:value-of select="@uri"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- Create a Wiki page for each Taxonomy node -->

<xsl:template match="node">
<xsl:variable name="name" select="translate(@title, ' ', '_')"/>
<xsl:result-document href="{$datadir}/{$name}.page">
<xsl:text>{{Taxonomy Node&#x0A;</xsl:text>
<xsl:choose>
  <xsl:when test="@emUUID = ''"><xsl:text>|uuid=</xsl:text><xsl:value-of select="@id"/><xsl:text>&#x0A;</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>|uuid=</xsl:text><xsl:value-of select="@emUUID"/><xsl:text>&#x0A;</xsl:text></xsl:otherwise>
</xsl:choose>
<xsl:if test="not(name(parent::node) eq 'taxonomy')">
<xsl:text>|order=</xsl:text><xsl:number from="standards/taxonomy" count="node" level="any"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|parent=</xsl:text><xsl:value-of select="translate(parent::node/@title, ' ', '_')"/><xsl:text>&#x0A;</xsl:text>
</xsl:if>
<xsl:text>|title=</xsl:text><xsl:value-of select="@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:value-of select="@description"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
<xsl:apply-templates/>
</xsl:template>


<!-- Create a Wiki page for each Standard -->

<xsl:template match="standard">
<xsl:variable name="myid" select="@id"/>
<xsl:if test="not(.//event[(position()=last()) and (@flag='deleted')])">
<xsl:result-document href="{$datadir}/{@id}.page">
<xsl:text>{{Standard&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|publisher=</xsl:text><xsl:value-of select="upper-case(document/@orgid)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="document/@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|dateissued=</xsl:text><xsl:value-of select="document/@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:apply-templates select="applicability"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|responsible=</xsl:text><xsl:value-of select="upper-case(responsibleparty/@rpref)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|website=</xsl:text><xsl:value-of select="status/uri"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:if>
</xsl:template>


<!-- Create a Wiki page for Capability Profile -->

<xsl:template match="capabilityprofile">
<xsl:result-document href="{$datadir}/{@id}.page">
<xsl:text>{{capability Profile&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|publisher=</xsl:text><xsl:value-of select="profilespec/@orgid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="profilespec/@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="profilespec/@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|dateissued=</xsl:text><xsl:value-of select="profilespec/@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|guideline=</xsl:text><xsl:apply-templates select="applicability"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|profiles=</xsl:text><xsl:apply-templates select="subprofiles/refprofile" mode="profiles"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|serviceprofiles=</xsl:text><xsl:apply-templates select="subprofiles" mode="serviceprofiles"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- Create a Wiki page for Profile -->

<xsl:template match="profile">
<xsl:result-document href="{$datadir}/{@id}.page">
<xsl:text>{{Profile&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|publisher=</xsl:text><xsl:value-of select="profilespec/@orgid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="profilespec/@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="profilespec/@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|dateissued=</xsl:text><xsl:value-of select="profilespec/@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|guideline=</xsl:text><xsl:apply-templates select="applicability"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|profiles=</xsl:text><xsl:apply-templates select="subprofiles/refprofile" mode="profiles"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|serviceprofiles=</xsl:text><xsl:apply-templates select="subprofiles" mode="serviceprofiles"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- Create a Wiki page for Service Profile -->

<xsl:template match="serviceprofile">
<xsl:result-document href="{$datadir}/{@id}.page">
<xsl:text>{{Service Profile&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- Handle subprofiles -->

<xsl:template match="refprofile" mode="profiles">
<xsl:variable name="myid" select="@refid"/>
<xsl:if test="/standards/records/profile[@id=$myid]"><xsl:text>{{Profile Group&#x0A;</xsl:text>
<xsl:text>|profiles=</xsl:text><xsl:value-of select="$myid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="refprofile" mode="serviceprofiles">
<xsl:variable name="myid" select="@refid"/>
<xsl:if test="/standards/records/serviceprofile[@id=$myid]"><xsl:text>{{Service Profile Group&#x0A;</xsl:text>
<xsl:text>|serviceprofiles=</xsl:text><xsl:value-of select="$myid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:if>
</xsl:template>


<!-- Generate an Event list  -->

<xsl:template match="status"><xsl:text>|events=</xsl:text><xsl:apply-templates select="history/event"/></xsl:template>

<!-- Generate an Event element  -->

<xsl:template match="event">
<xsl:text>{{Change Event&#x0A;</xsl:text>
<xsl:text>|order=</xsl:text><xsl:number from="parent:status" count="event"><xsl:text>&#x0A;</xsl:text>
<xsl:text>|date=</xsl:text><xsl:value-of select="@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|flag=</xsl:text><xsl:value-of select="@flag"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|rfcp=</xsl:text><xsl:value-of select="@rfcp"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|version=</xsl:text><xsl:value-of select="@version"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:template>

</xsl:stylesheet>
