package com.company;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("prod")
public class Profile_Prod {
	@Bean
	public JndiConnectionProvider connProvider(){
		JndiConnectionProvider cp = new JndiConnectionProvider();
		cp.setJndiName("java:/comp/env/jdbc/dv");
		return cp;
	}
}
