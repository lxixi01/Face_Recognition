
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>刷脸门禁登录系统</title>
<style type="text/css">
body {
	background: url("./images/bg.jpg") no-repeat;
	background-size: 100% auto;
	background-attachment: fixed;
}

h1 {
	text-align: center;
}

.message {
	text-align: center;
	color: red;
}

.media {
	width: 600px;
	height: 400px;
	margin: 20px auto;
	position: relative;
	overflow: hidden;
}

.media .m_scan {
	width: 100%;
	height: 100%;
	position: absolute;
	background: rgba(0, 100, 200, 0.4);
}

.btn_recognition {
	display: block;
	width: 80px;
	height: 40px;
	margin: 20px auto;
	background: teal;
	text-align: center;
	line-height: 40px;
	font-size: 16px;
	color: white;
	text-decoration: none;
	border-radius: 10px;
}

.btn_recognition:hover {
	background: orange;
}
.a_register{
	display: block;
	width: 160px;
	height: 20px;
	margin: 0px auto;
	background: green;
	text-align: center;
	line-height: 20px;
	font-size: 14px;
	color: white;
}
</style>

</head>
<body>
	<h1>刷脸吧</h1>
	<h2 class="message"></h2>
	<div class="media">
		<video id="video" width="600" height="400"></video>
		<canvas id="canvas" width="600" height="400"></canvas>
		<div class="m_scan"></div>
	</div>
	<a href="#" class="btn_recognition">点击识别</a>
	<a href="/Face_Recognition/faceregister.jsp" class="a_register">去注册一张脸吧</a>
</body>
<script type="text/javascript" src="./js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
            var video = document.getElementById("video");
            var canvas = document.getElementById("canvas");
        	$(function(){
        		//初始化摄像头
        		init_getvideo();
        		//点击按钮
        		$(".btn_recognition").click(function(){
	        		scan();
        		});
        	});
        	//初始化调用系统摄像头
        	function init_getvideo(){
        		//浏览器兼容性
        		var getUserMedio = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia);
        		//navigator 浏览器内置对象
        		getUserMedio.call(navigator,{
        			video: true,
        			audio: false
        		},function(localMediaStream){  
        			//将摄像头的流媒体赋值给video标签
        			video.src = window.URL.createObjectURL(localMediaStream);
        			video.onloadedmetadata = function(e){
        				video.play();
        			};
        		},function(e){
        			console.log("出错了!",e);
        		});
        	}
        	//图像扫描
       		function scan(){
       			var box = $(".media");
       			$(".m_scan").css({"bottom":box.height()}).animate({bottom:0},1000,function(){
       				$(this).css({"bottom":box.height()});
       			});
       			//绘制canvas图形
		        canvas.getContext('2d').drawImage(video, 0, 0, 600, 400);
		        //把canvas图像转为img图片
		        var str = canvas.toDataURL("image/png");
		        //将字符串截取base64位部分
		        var base64 = str.split("base64,")[1];
			    $.ajax({
					url: '/Face_Recognition/servlet/LoginFace',
					type: 'POST',
					data:{img:base64},
					dataType: 'text',
					async: true,//异步
					timeout: 8000,
					error: function(){
						alert('操作错误,请与系统管理员联系!');
					},
					success: function(data){
					if($.trim(data) == 'true'){
						window.location.href="welcome.jsp";
					}else{
						$(".message").text("你长得太丑了，换一个跟xixi一样的男神过来!");
					}
					}
				});
       		}
        </script>
</html>