package config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import com.company.AsyncService;


/**
 * servlet-context.xml
 * @author guanho
 *
 */
@Configuration
@EnableWebMvc
@ComponentScan(
		basePackages="com.company",
 		excludeFilters=@ComponentScan.Filter(Configuration.class)
)
@Import(TaskConfig.class)
public class MvcConfig extends WebMvcConfigurerAdapter{
	
	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
    }
	
	@Bean
	public AsyncService asyncService(){
		AsyncService asyncService = new AsyncService();
		return asyncService;
	}
	
	
	@Bean
	public BeanNameViewResolver vbeanNameViewResolver(){
		BeanNameViewResolver viewResolver = new BeanNameViewResolver();
		return viewResolver;
	}
	
	
	@Bean
	public ViewResolver viewResolver(){
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
		resolver.setPrefix("/WEB-INF/view/");
		resolver.setSuffix(".jsp");
		return resolver;
	}
}
