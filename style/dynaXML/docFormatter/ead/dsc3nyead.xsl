
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf"
	xmlns="http://www.w3.org/1999/xhtml" version="1.0">

	<!-- This stylesheet formats the dsc where
	components have a single container element.-->
	<!--It assumes that c01 is a high-level description such as
	a series, subseries, subgroup or subcollection and does not have
	container elements associated with it.-->
	<!--Column headings for containers are inserted whenever
	the value of a container's type attribute differs from that of
	the container in the preceding component. -->
	<!-- The value of a column heading is taken from the type
    attribute of the container element.-->
	<!--The content of container elements is always displayed.-->
	<!-- c02 as subseries altered to provide anchor names when the info has been omitted -->


	<!-- .................Section 1.................. -->
	<!-- line break template -->

	<xsl:template match="lb">
		<br/>
	</xsl:template>


	<!--This section of the stylesheet formats dsc and
any introductory paragraphs.-->

	<xsl:template match="archdesc/dsc">
		<xsl:apply-templates/>
		<xsl:call-template name="btop"/>
		<span class="section_divider">
			<hr/>
		</span>

	</xsl:template>



	<xsl:template match="dsc/p | dsc/note/p">
		<p style="margin-left:25pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

<!-- not for use in NYEAD at this time 
	<xsl:template name="did-dao">
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="did/dao/@href"/>
			</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:text>_blank</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="archdesc/dsc//did/dao"/>
			<img src="../xtf/icons/default/camicon.gif" border="0" alt="icon"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="dsc//unittitle/unitdate">
		<span class="clist_unitdate">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<!-- will  create separate line for work number when it is stated within a unittitle, followed by a title. 
		It may need to be rewritten to apply only to num as the first element within unittitle -->

	<xsl:template match="unittitle/num">
		<xsl:if test="following-sibling::title">
			<span class="worknumber">
				<xsl:apply-templates/>
				<br/>
			</span>
		</xsl:if>
	</xsl:template>

	<!-- will  add a class for persname and a line break between personal name and title in unittitle -->

	<xsl:template match="unittitle/persname">
		<xsl:choose>
			<xsl:when test="following-sibling::persname[last()=1]">
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
			</xsl:when>


			<xsl:when test="following-sibling::title[1]">
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- will differentiate titles by type -->

	<xsl:template match="dsc//title">
		<xsl:choose>
			<xsl:when test="@type='uniform'">
				<span class="uniformtitle">
					<xsl:text>Uniform title: </xsl:text>
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>

			<xsl:when test="@type='transcribed'">
				<span class="transcribedtitle">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>

			<xsl:when test="@type='journal' or @type='book' or @render='italic'">
				<span class="italicstitle">
					<xsl:apply-templates/>
				</span>
			</xsl:when>

			<xsl:when test="@type='review' or @type='course' or @type='article' or @type='chapter'">
				<span class="quotestitle">
					<xsl:text>&#x201C;</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>&#x201D;</xsl:text>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="titlenotype">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- ................Section 2 ...........................-->
	<!--This section of the stylesheet contains two templates
that are used generically throughout the stylesheet.-->

	<!--This template formats the unitid, origination, unittitle,
	unitdate, and physdesc elements of components at all levels.  They appear on
	a separate line from other did elements. It is generic to all
	component levels.-->

	<xsl:template name="component-did">
		<!--Inserts unitid and a space if it exists in the markup.-->
		<xsl:if test="unitid">


			<xsl:text/>
			<xsl:apply-templates select="unitid"/>
			<xsl:text>&#x00A0;&#x00A0;&#x00A0;&#x00A0;</xsl:text>


		</xsl:if>

		<!--This choose statement selects between cases where unitdate is a child of
		unittitle and where it is a separate child of did.-->
		<xsl:choose>
			<!--This code processes the elements when unitdate is a child
			of unittitle.-->
			<xsl:when test="unittitle">

				<xsl:for-each select="unittitle">
					<span class="unittitle">
						<xsl:apply-templates/>
					</span>
					<xsl:text>&#x20;</xsl:text>
				</xsl:for-each>
			</xsl:when>

			<!--This code process the elements when unitdate is not a
					child of untititle-->
			<xsl:otherwise>
				<span class="unittitle">
					<xsl:apply-templates select="unittitle"/>
				</span>
				<xsl:text>&#x20;</xsl:text>
				<xsl:for-each select="unitdate">
					<span class="clist_unitdate">
						<xsl:apply-templates/>
					</span>

				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="dao">
			<xsl:text>&#x20;&#x20;</xsl:text>
			<xsl:apply-templates select="dao"/>
		</xsl:if>


		<xsl:if test="physdesc">
			<br/>
			<span class="series-physdesc">
				<xsl:apply-templates select="physdesc"/>
			</span>
		</xsl:if>
		<xsl:if test="physloc">
			<br/>
			<span class="series-physloc">
				<xsl:apply-templates select="physloc"/>
			</span>
		</xsl:if>
		<!--Inserts origination and a space if it exists in the markup.-->
		<xsl:if test="origination">

			<br/>
			<span class="listcreators">
				<xsl:value-of select="origination/@label"/>
				<xsl:text>&#x20;</xsl:text>
				<xsl:apply-templates select="origination"/>
				<xsl:text>&#x20;</xsl:text>
			</span>
		</xsl:if>

	</xsl:template>

	<!-- ...............Section 3.............................. -->
	<!--This section of the stylesheet creates an HTML table for each c01.
It then recursively processes each child component of the
c01 by calling a named template specific to that component level.
The named templates are in section 4.-->

	<xsl:template match="c01">
		<xsl:for-each select=".">
			<xsl:choose>
				<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
					<div class="c01">
						<xsl:call-template name="c01-level"/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="c02">
						<xsl:call-template name="c02-level-container"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:for-each select="c02">
				<xsl:choose>
					<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
						<div class="c02">
							<xsl:call-template name="c02-level-subseries"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="c02">
							<xsl:call-template name="c02-level-container"/>
						</div>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:for-each select="c03">
					<xsl:choose>
						<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
							<xsl:call-template name="c03-level-subseries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="c03-level-container"/>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:for-each select="c04">
						<xsl:choose>
							<xsl:when
								test="@level='subseries' or @level='series' or @level='subgrp'">
								<xsl:call-template name="c04-level-subseries"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="c04-level-container"/>
							</xsl:otherwise>
						</xsl:choose>

						<xsl:for-each select="c05">
							<xsl:call-template name="c05-level"/>

							<xsl:for-each select="c06">
								<xsl:call-template name="c06-level"/>

								<xsl:for-each select="c07">
									<xsl:call-template name="c07-level"/>

									<xsl:for-each select="c08">
										<xsl:call-template name="c08-level"/>

										<xsl:for-each select="c09">
											<xsl:call-template name="c09-level"/>

											<xsl:for-each select="c10">
												<xsl:call-template name="c10-level"/>
											</xsl:for-each>
											<!--Closes c10-->
										</xsl:for-each>
										<!--Closes c09-->
									</xsl:for-each>
									<!--Closes c08-->
								</xsl:for-each>
								<!--Closes c07-->
							</xsl:for-each>
							<!--Closes c06-->
						</xsl:for-each>
						<!--Closes c05-->
					</xsl:for-each>
					<!--Closes c04-->
				</xsl:for-each>
				<!--Closes c03-->
			</xsl:for-each>
			<!--Closes c02-->
		</xsl:for-each>
		<!--Closes c01-->
	</xsl:template>

	<!-- ...............Section 4.............................. -->
	<!--This section of the stylesheet contains a separate named template for
each component level.  The contents of each is identical except for the
spacing that is inserted to create the proper column display in HTML
for each level.-->

	<!--Processes c01 which is assumed to be a series
	description without associated components.-->
	<xsl:template name="c01-level">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<xsl:for-each select="did">
				<tr>
					<td colspan="3"> &#x20;</td>
				</tr>
				<tr>
					<td width="95%" align="left" valign="top">
						<!-- version to supply counted c01s
						<a>
							<xsl:attribute name="name">
								<xsl:text>series</xsl:text><xsl:number from="dsc" count="c01 "/>
							
							</xsl:attribute>
							<div class="series1">
								<span class="component_did"><xsl:call-template name="component-did"/></span>
							</div>
							</a> -->
						<a>
							<xsl:attribute name="name">
								<xsl:value-of select="unitid/@id"/>
							</xsl:attribute>
							<div class="series1">
								<span class="component_did">
									<xsl:call-template name="component-did"/>
								</span>
							</div>
						</a>
					</td>
				</tr>
				<xsl:for-each select="note/p | langmaterial | materialspec">
					<tr>
						<td width="95%" valign="top">
							<br/>
							<xsl:apply-templates/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
			<!--Closes the did.-->

			<!--This template creates a separate row for each child of
		the listed elements. Do we need HEADS for these components? -->
			<xsl:for-each
				select="scopecontent | bioghist | arrangement 
		| userestrict | accessrestrict | processinfo |
		acqinfo | custodhist | controlaccess/controlaccess | odd | note
		| descgrp/*">
				<!--The head element is rendered in bold.-->
				<xsl:for-each select="head">
					<tr>
						<td width="95%" valign="top">
							<b>
								<xsl:apply-templates/>
							</b>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="*[not(self::head)]">
					<tr>
						<td width="95%" valign="top">
							<span class="series1_element">
								<p>
									<xsl:apply-templates/>
								</p>
							</span>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>

	<!--This template processes c02 elements that have associated containers, for
	example when c02 is a file.-->
	<xsl:template name="c02-level-container">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
							'abcdefghijklmnopqrstuvwxyz',
							'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
							), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
							'abcdefghijklmnopqrstuvwxyz',
							'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
							), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<xsl:call-template name="component-did"/>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<div class="listnotes">
									<xsl:apply-templates/>
								</div>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<p class="seriesleveltext">
									<xsl:apply-templates/>
								</p>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c02 level components that do not have
	associated containers, for example if the c02 is a subseries.-->


	<xsl:template name="c02-level-subseries">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<xsl:for-each select="did">
				<tr>
					<td colspan="3">&#x20;</td>
				</tr>
				<tr>
					<td width="95%" align="left" valign="top">
						<div class="series2">
							<!-- this CHOOSE provides a name for an anchor for those unitid elements that were not assigned id attributes. 
	This allows links to be created from a table of contents (see eadDocFormatter.xsl) 
	without overwriting ids already written in as id attributes in unitid. This could be repeated at c03 level if c03's are ever reflected in table of contents -->

							<xsl:choose>
								<xsl:when test="unitid[@id]">
									<a>
										<xsl:attribute name="name">
											<xsl:value-of select="unitid/@id"/>
										</xsl:attribute>
									</a>
								</xsl:when>
							<!--	<xsl:otherwise>
									<a name="{xtf:make-id(.)}"/>
								</xsl:otherwise> -->
							</xsl:choose>
							<span class="pageheadline_smm">
								<!-- <xsl:text>Subseries </xsl:text> -->
								<span class="component_did">
									<xsl:call-template name="component-did"/>
								</span>
							</span>

						</div>
					</td>
				</tr>
				<xsl:for-each select="note/p | langmaterial | materialspec">
					<tr>
						<td width="95%" valign="top">
							<br/>
							<xsl:apply-templates/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
			<!--Closes the did.-->







			<!--This template creates a separate row for each child of
				the listed elements. Do we need HEADS for these components? -->
			<xsl:for-each
				select="scopecontent | bioghist | arrangement 
				| userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note
				| descgrp/*">
				<!--The head element is rendered in bold.-->
				<xsl:for-each select="head">
					<tr>
						<td width="95%" valign="top">
							<b>
								<xsl:apply-templates/>
							</b>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="*[not(self::head)]">
					<tr>
						<td width="95%" valign="top">
							<span class="series2_element">
								<xsl:apply-templates/>
							</span>
						</td>
					</tr>
					<tr>
						<td width="95%" valign="top" height="10">
							<xsl:text>&#x20;</xsl:text>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>

	<!--This template processes c03 elements that have associated containers, for
		example when c03 is a file.-->
	<xsl:template name="c03-level-container">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<div class="listnotes">
									<xsl:apply-templates/>
								</div>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo | 
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<span class="series3_element">
									<p>
										<xsl:apply-templates/>
									</p>
								</span>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c03 level components that do not have
		associated containers, for example if the c03 is a subseries.-->
	<xsl:template name="c03-level-subseries">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<xsl:for-each select="did">
				<tr>
					<td colspan="3">&#x20;</td>
				</tr>


				<tr>
					<td width="95%" align="left" valign="top" class="componenttext">
						<div class="series3">
							<a>
								<xsl:attribute name="name">
									<!-- originally <xsl:text>subseries</xsl:text><xsl:number from="dsc" count="c03"/> -->
									<xsl:value-of select="unitid/@id"/>
								</xsl:attribute>
								<span class="pageheadline_smm">
									<span class="component_did">
										<xsl:call-template name="component-did"/>
									</span>
								</span>
							</a>
						</div>
					</td>
				</tr>
				<xsl:for-each select="note/p | langmaterial | materialspec">
					<tr>
						<td width="95%" valign="top">
							<xsl:apply-templates/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
			<!--Closes the did.-->

			<!--This template creates a separate row for each child of
			the listed elements.-->
			<xsl:for-each
				select="scopecontent | bioghist | arrangement 
			| userestrict | accessrestrict | processinfo | 
			acqinfo | custodhist | controlaccess/controlaccess | odd | note
			| descgrp/*">
				<!--The head element is rendered in bold.-->
				<xsl:for-each select="head">
					<tr>
						<td width="95%" valign="top">
							<b>
								<xsl:apply-templates/>
							</b>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="*[not(self::head)]">
					<tr>

						<td width="95%" valign="top">
							<span class="series3_element">
								<p>
									<xsl:apply-templates/>
								</p>
							</span>
						</td>
					</tr>
					<tr>
						<td width="95%" valign="top" height="10">
							<xsl:text>&#x20;</xsl:text>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>

	<!--This template processes c04 elements that have associated containers, for
		example when c04 is a file.-->
	<xsl:template name="c04-level-container">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<div class="listnotes">
									<xsl:apply-templates/>
								</div>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<p class="seriesleveltext">
									<xsl:apply-templates/>
								</p>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<xsl:template name="c04-level-subseries">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<xsl:for-each select="did">
				<tr>
					<td colspan="3">&#x20;</td>
				</tr>
				<tr>
					<td width="95%" align="left" valign="top" class="componenttext">
						<a>
							<xsl:attribute name="name">
								<!-- originally <xsl:text>subseries</xsl:text><xsl:number from="dsc" count="c04 "/> -->
								<xsl:value-of select="unitid/@id"/>
							</xsl:attribute>
							<div class="series3">
								<span class="component_did">
									<xsl:call-template name="component-did"/>
								</span>
							</div>
						</a>
					</td>
				</tr>
				<xsl:for-each select="note/p | langmaterial | materialspec">
					<tr>
						<td width="95%" valign="top">
							<br/>
							<xsl:apply-templates/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
			<!--Closes the did.-->

			<!--This template creates a separate row for each child of
				the listed elements. Do we need HEADS for these components? -->
			<xsl:for-each
				select="scopecontent | bioghist | arrangement 
				| userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note
				| descgrp/*">
				<!--The head element is rendered in bold.-->
				<xsl:for-each select="head">
					<tr>
						<td width="95%" valign="top">
							<b>
								<xsl:apply-templates/>
							</b>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="*[not(self::head)]">
					<tr>
						<td width="95%" valign="top">
							<span class="series4_element">
								<xsl:apply-templates/>
							</span>
						</td>
					</tr>
					<tr>
						<td width="95%" valign="top" height="10">
							<xsl:text>&#x20;</xsl:text>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>

	<!--This template processes c05 elements that have associated containers, for
		example when c05 is a file.-->
	<xsl:template name="c05-level">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<br/>
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c06 elements that have associated containers, for
		example when c06 is a file.-->
	<xsl:template name="c06-level">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<br/>
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c07 elements that have associated containers, for
		example when c07 is a file.-->
	<xsl:template name="c07-level">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<span class="component_did">
									<xsl:call-template name="component-did"/>
								</span>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<br/>
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c08 elements that have associated containers, for
		example when c08 is a file.-->
	<xsl:template name="c08-level">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<br/>
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c09 elements that have associated containers, for
		example when c09 is a file.-->
	<xsl:template name="c09-level">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<br/>
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--This template processes c10 elements that have associated containers, for
		example when c10 is a file.-->
	<xsl:template name="c10-level">
		<span class="item_record">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<xsl:for-each select="did">
					<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
						<tr>
							<td colspan="3">&#x20;</td>
						</tr>
						<tr valign="top">
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[1]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[1]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="15%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:value-of
											select="concat(translate(substring(container[2]/@type, 1, 1),
									'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									), substring(container[2]/@type, 2))"
										/>
									</span>
								</b>
							</td>
							<td width="70%" align="left" valign="top" class="componenttext">
								<b>
									<span class="column-head">
										<xsl:text>Contents</xsl:text>
									</span>
								</b>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="3">&#x20;</td>
					</tr>
					<tr>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[1]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="15%" valign="top" class="componenttext">
							<span class="numbering">
								<xsl:value-of select="container[2]"/>
								<xsl:text>&#x20;</xsl:text>
							</span>
						</td>
						<td width="70%" valign="top">
							<div class="containertext">
								<xsl:call-template name="component-did"/>
							</div>
						</td>
					</tr>

					<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>

				</xsl:for-each>
				<!--Closes the did.-->

				<xsl:for-each
					select="scopecontent | bioghist | arrangement |
				userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
					<!--The head element is rendered in bold.-->
					<xsl:for-each select="head">
						<tr>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<b>
									<xsl:apply-templates/>
								</b>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<tr>

							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="15%">
								<xsl:text>&#x20;</xsl:text>
							</td>
							<td width="70%" valign="top">
								<br/>
								<xsl:apply-templates/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</span>
	</xsl:template>

	<!--BACK TO TOP TEMPLATE-->

	<xsl:template name="btop">
		<div class="bttop" align="center">
			<a href="#top" class="itoc">[Return to Top]</a>
		</div>
	</xsl:template>

	<!--END OF BACK TO TOP TEMPLATE-->
</xsl:stylesheet>
