# TIL

##Description
> 오늘 나는 무었을 하였는가?? 배운거에 대해서 적는거이지만 올라오지 않을때가 더 많은 곳.... 언젠가는 저 폴더들안에 내용이 꽉 차겠지....

##Start
* 2016-07 ~



##less

요즘 들어 알게됬는 css preprocessor(전처리기)에 대해 설명하보려 한다.
css preprocessor는 3가지 정도가 있다고 들었다.
sass, less, stylus
<br><br>
대부분은 sass를 쓰고 일부분이 less를 쓰고 stylus는 거의 쓰지 않는다고 알고있다.
sass, less 둘다 css 보다 엄청 편하게 쓸수 있다고 하는데
sass를 많이 쓰는 이유가
* 가장 오래된 걸로 알고있다.
* 더 많은 기능이 있다
* if문이 있다.
이걸로 알고 있지만 나는 less를 선택했다.
less를 선택하는 이유는  sass는 ruby환경으로 구성되어 있어서 느리다고 한다.
아무 이유없다....
<br><br>
내가 css preprocessor를 선택하는 이유는 프론트엔드를 할때 공통적인 색깔들이 있을텐데 그 색깔이
바뀔때가 있는데 프로젝트에서 해당 색을 찾아서 모든곳을 바꿔주는게 너무 귀찮았다.
GDG에 갔을때 css에 변수가 생긴다고 들었고 다른 분들께 이말을 전했더니 sass나 less를 언급했었다.
그 기억을 되살려 검색하게 되었고 내가 원하는 기능들이 있었다.
<br><br>
0. 사용법

나는 스크립트로 변환해서 사용하는게 편하다.
<a href="http://lesscss.org/" target="_blank">http://lesscss.org/</a>여기서 less.js파일을 다운받는다.
~~~~
<!DOCTYPE html>
<html>
<head>
<title>hello less</title>
<link href="./common.less" type="text/css" rel="stylesheet/less">
<script src="./less.min.js" type="text/javascript"></script>
<head>
<body>
<content>
  <header>hello</header>
  <section>
  	<div>
  		<span class="title"><a>hi</a></span>
  		<span class="date">2016-07-14</span>
  	</div>
  	<div>
  		<span class="less"><a>hi</a></span>
  		<span class="date">2016-07-14</span>
  	</div>
  	<div>
  		<span class="world"><a>hi</a></span>
  		<span class="date">2016-07-14</span>
  	</div>
  	<p>ppppp</p>
  	<span class="round">
  		round!!!
  	</span>
  </section>
  <bottom>
  	<div>bye.</div>
  </bottom>
</content>
</body>

~~~~
이런식으로 head태그 안에 쓰면 된다.

<br><br>
1.변수
~~~~
@commonColor: #f1f1f1;
@headerColor: #ff495e;
@headerFontColor: #5b83ad;

body{background-color: @commonColor;}
header{background-color: @headerColor; color: @headerFontColor;}
~~~~
이런 식으로 나타낼 수 있다.
<br><br>
2.중첩
~~~~
section{
  width: 100%; margin-top: 50px;
  div{
    width: 60%; height: 40px; border-bottom: 1px solid green;
    .title{
      text-align: left;
      a{text-decoration:none; cursor:pointer;}
    }
    .date{text-align: center;}
  }
}

~~~~
내가 자주 사용하는 패턴이다.
css보다 보기가 더 편하고 직관성이 뛰어난거 같다.
css보다 코드수를 대폭 줄일수 있다.
<br><br>


3.계산식

~~~~
bottom{
	@width : 80px;
	@height : @width/4*5;
	div{margin-top: 100px; width: @width; height: @height; border: 1px solid red; float: left;}
}

@color: #c1c1c1;
@padding: 10px;
p{
  background: fadeout(@color, 50%);
  padding: @padding+50;
}
~~~~
간단간단한 계산식도 가능하다.
%계산이나 사칙연산정도.

<br><br>
4.임포트
~~~~
@import (less) "./index";
@import (less) "../certificate/joinConsumer";
~~~~
간단하게 포함시키는거다. @import뒤에 (less)를 적어서 자동으로 less파일을 포함시킨다.


<br><br>
5.믹스인(sass는 @mixin으로 쓴다.)
~~~~
.round_5(@radius: 20px){
  border-radius: @radius;
  -moz-border-radius: @radius;
  -webkit-border-radius: @radius;
}
span.round{.round_5; float: left; border: 1px solid orange; width: 60px; height: 60px;}
~~~~
이런식으로 쓸 수 있다. 아주 좋은 기능이고 진짜 많이 쓰인다는데 나는 아직 안써봤다.

<br><br>
6.자바스크립트실행

~~~~
@wellcome: '"hello world".toUpperCase()+"~~~~~"';

@wellcome: "HELLO WORLD~~~~~";

@screenWidth: 'document.body.clientWidth';
@screenHeight: 'document.body.clientHeight';

~~~~

와우!!! css에서 스크립트를 쓴다.....
@wellcome 라고 작성된 두가지는 똑같은 거고
브라우저의 width, height를 가져올수도 있다.
진짜 대단한 기능


<br><br>
