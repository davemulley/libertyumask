package com.example.demo.controller;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LibertyUmaskController {
	
	@RequestMapping("/greeting")
    public String index(@RequestParam(defaultValue = "Default Name") String name)
    {
		createFile(name, name);
		return "Hello world " + name;
      
    }
	
	private void createFile(String filename, String text) {
		
		try {
			  String fname = "/tmp/" + filename.replaceAll("\\s+", "") + ".txt";
		      File myObj = new File(fname);
		      if (myObj.createNewFile()) {
		        System.out.println("File created: " + myObj.getName());
		      } else {
		        System.out.println("File already exists.");
		      }
		      FileWriter myWriter = new FileWriter(fname);
		      myWriter.write(text);
		      myWriter.close();
		    } catch (IOException e) {
		      System.out.println("An error occurred.");
		      e.printStackTrace();
		    }
	}
}
