package com.company;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
public class Profile_reiteration {
	@Configuration
	@Profile("dev")
	public static class DataSourceDev{
		@Value("${db.driver}")
		private String driver;
		@Bean
		public ConnectionProvider connProvider(){
			return new JndiConnectionProvider();
		}
	}
	
	@Configuration
	@Profile("prod")
	public static class DataSourceProd{
		@Bean
		public ConnectionProvider connProvider(){
			JndiConnectionProvider jcp = new JndiConnectionProvider();
			jcp.setJndiName("java:/comp/env/jdbc/db");
			return jcp;
		}
	}
}
