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

import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileReader;

public class Main {
    public static void main(String[] args) {
        if(args.length != 1) {
            System.err.println("Usage : mif2xml <inputfile>");
            System.exit(1);
        }

        try {
            MifLexer scanner = new MifLexer(new FileReader(args[0]));
            System.out.print("<?xml version=\"1.0\"?><mif>");
            scanner.yylex();
            System.out.print("</mif>");
        } catch(FileNotFoundException e) {
            System.out.println("File not found : "+args[0]);
        } catch(IOException e) {
            System.out.println("I/O error scanning file '"+args[0]+"': "+e.getMessage());
        } catch(Exception e) {
            System.out.println("Unexpected exception: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
