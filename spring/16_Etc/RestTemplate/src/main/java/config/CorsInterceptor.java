package config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


/**
 * CORS 를 위한 인터셉터.
 * Origin 헤더가 request 에 존재할 경우, CORS 가능하도록 응답 헤더를 추가한다.
 * 
 * @author guanho
 *
 */
public class CorsInterceptor implements HandlerInterceptor{
	private static final String  ACCESS_CONTROL_ALLOW_ORIGIN      = "Access-Control-Allow-Origin";
	private static final String  ACCESS_CONTROL_ALLOW_CREDENTIALS = "Access-Control-Allow-Credentials";
	private static final String  REQUEST_HEADER_ORIGIN            = "Origin";
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
		String origin = request.getHeader(REQUEST_HEADER_ORIGIN);
		if (StringUtils.hasLength(origin)){// CORS 가능하도록 응답 헤더 추가
			response.setHeader(ACCESS_CONTROL_ALLOW_ORIGIN, origin); // 요청한 도메인에 대해 CORS 를 허용한다. 제한이 필요하다면 필요한 값으로 설정한다.
			response.setHeader(ACCESS_CONTROL_ALLOW_CREDENTIALS, "true");// credentials 허용
		}
		return true;
	}
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception{
		
	}
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception{
		
	}
}
