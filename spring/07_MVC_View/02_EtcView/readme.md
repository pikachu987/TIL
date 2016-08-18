### HTML 이외의 뷰 구현

#### 파일 다운로드
파일 다운로드 구현을 위한 커스텀 View
파일 다운로드를 구현하려면 컨텐트 타입을 "application/octet-stream"과 같이 다운로드를 위한 타입으로 설정해주어야 하며, 다운로드 받는 파일 이름을 알맞게 설정하려면 Content-Disposition 헤더의 값을 알맞게 설정해주어야 한다.

~~~~
public class Download extends AbstractView{
	public Download() {
		setContentType("application/download; charset=utf-8"); 
	}
	@Override
	protected void renderMergedOutputModel(Map<String, Object> arg0, HttpServletRequest arg1, HttpServletResponse arg2)
			throws Exception {
		File file = (File) arg0.get("downloadFile");
		arg2.setContentType(getContentType());
		arg2.setContentLength((int)file.length());
		
		String userAgent = arg1.getHeader("User-Agent");
		boolean ie = userAgent.indexOf("MSIE") > -1;
		String fileName = null;
		if(ie){
			fileName = URLEncoder.encode(file.getName(), "utf-8");
		}else{
			fileName = new String(file.getName().getBytes("utf-8"), "iso-8859-1");
		}
		arg2.setHeader("Content-Disposition", "attachment; filename=\""+ fileName +"\";");
		arg2.setHeader("Content-Transfer-Encoding", "binary");
		OutputStream out = arg2.getOutputStream();
		FileInputStream fis = null;
		try{
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		}finally{
			if(fis != null)
				try{
					fis.close();
				}catch(IOException e){
					
				}
		}
		out.flush();
	}
	
}

~~~~

파일 다운로드를 위해 컨텐트 타입을 "application/download" 로 설정해줘야 한다.
파일 다운로드와 관련된 헤더를 알맞게 설정한 뒤에는 response의 OutputStream에 파일을 출력하면 된다.


#### 엑셀 다운로드

~~~~
<dependency>
	<groupId>org.apache.poi</groupId>
	<artifactId>poi</artifactId>
	<version>3.9</version>
</dependency>
~~~~

의존을 추가하여야 한다.


AbstractExcelView 클래스는 엑셀 응답 결과를 생성하기 위한 기본 기능을 제공하고 있으며, 이 클래스를 상속 받은 뒤 다음의 메서드만 알맞게 재정의한다.
~~~~
protected abstract void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception;
~~~~

HSSFWorkbook은 POI API가 제공하는 엑셀 관련 클래스이다.

bulidExcelDocument() 메서드는 엑셀 파일을 생성하는데 필요한 HSSFWorkboox 객체를 파라미터로 전달받는데, 이 객체를 이용해서 알맞게 엑셀 데이터를 생성하면 된다.
> https://poi.apache.org/spreadsheet/ 참조


#### PDF 다운로드

~~~~
<dependency>
	<groupId>com.lowagie</groupId>
	<artifactId>itext</artifactId>
	<version>2.1.7</version>
	<exclusions>
		<exclusion>
			<groupId>bouncycastle</groupId>
			<artifactId>bcmail-jdk14</artifactId>
		</exclusion>
		<exclusion>
			<groupId>bouncycastle</groupId>
			<artifactId>bcprov-jdk14</artifactId>
		</exclusion>
		<exclusion>
			<groupId>bouncycastle</groupId>
			<artifactId>bctsp-jdk14</artifactId>
		</exclusion>
	</exclusions>
</dependency>
~~~~

의존 추가한다.
exclustions 부분은 iText를 사용하기 위해 추가로 필요한 모듈 중에서 사용하지 않을 모듈을 지정한 것으로 암호화 관련된 기능을 제외시켰다.


AbstractPdfView 클래스를 상속받은 클래스는 다음의 메서드를 알맞게 재정의해서 PDF를 생성하면 된다.

~~~~
protected abstract void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer, HttpServletRequest request, HttpServletResponse response) throws Exception
~~~~

com.lowagie.text.Document 클래스는 iText가 제공하는 클래스로서, Document 객체에 PDF 문서를 생성하는 데 필요한 데이터를 추가함으로써 PDF 문서를 생성할 수 있다.


> 자세한 내용은 http://www.lowagie.com/iText/ 참조