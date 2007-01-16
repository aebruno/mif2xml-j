/*
 * Copyright 2007 Andrew Bruno <aeb@qnot.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

package org.qnot.mif2xml;

public class Tag {
    private String name;
    private String value;

    public String getName() {
        return this.name;
    }

    public String getValue() {
        return this.value;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public void writeEnd() {
        if(value != null && value.length() > 0) {
            System.out.print(escape(value) + "</" + name + ">");
        } else {
            System.out.print("</" + name + ">");
        }
    }

    public void writeStart() {
        System.out.print("<" + name + ">" );
    }

    public static void writeFacet(String facet) {
        System.out.print("<_facet><![CDATA[");
        System.out.print(facet);
        System.out.print("]]></_facet>");
    }

    private String escape(String str) {
        str = str.replaceAll("&", "&amp;");
        str = str.replaceAll("\"", "&quot;");
        str = str.replaceAll(">", "&gt;");
        str = str.replaceAll("<", "&lt;");
        str = str.replaceAll("^\\s+", "");
        str = str.replaceAll("\\s+$", "");

        return str;
    }
}
