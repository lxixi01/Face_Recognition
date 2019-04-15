    <%@ page language="java" contentType="text/html; charset=UTF-8"
             pageEncoding="UTF-8" %>
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
        <html>
        <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>刷脸门禁系统注册页面</title>
        <style type="text/css">
        	body{
        		background: url("./images/bg.jpg") no-repeat;
        		background-size:100% auto;
        		background-attachment: fixed;
        	}
        	h1{
        		text-align: center;
        	}
        	.message{
        		text-align: center;
        		color: red;
        	}
        	.content{
        		width: 1002px;
        		height: 402px;
        	}
        	.content .media{
        		width: 600px;
        		height: 400px;
        		position: relative;
        		overflow: hidden;
        		float: left;
        	}
        	.content .media .m_scan{
        		width: 100%;
        		height: 100%;
        		position: absolute;
        		background: rgba(0,100,200,0.4);
        	}
        	.content .faceinfo{
        		width: 400px;
        		height: 358px;
        		border: 1px solid black;
        		text-align: center;
        		float: left;
        	}
        	
        	.content .faceinfo .box_snap{
        		width: 400px;
        		height: 300px;
        	}
        	.content .faceinfo .box_snap p{
        		background: skyblue;
        		color: green;
        		margin: 0px auto;
        	}
        	.content .faceinfo .box_snap img{
        		margin-left: 20px;
        	}
        	.content .faceinfo .btn_snap{
        		display: block;
        		margin: 0px auto;
        		width: 80px;
        		height: 26px;
        		background: green;
        		text-align: center;
        		font-size: 14px;
        		color: white;
        	}
        	.content .faceinfo .btn_snap:hover{
        		background: orange;
        	}
        	.content .btn_submit{
        		display: block;
        		margin: 10px auto;
        		width: 80px;
        		height: 26px;
        		background: yellow;
        		text-align: center;
        		font-size: 14px;
        		color: blue;
        	}
        </style>
        
        </head>
        <body>
            <h1>刷脸注册</h1>
            <h2 class="message"></h2>
            <div class="content">
	            <div class="media">
					<video id="video" width="600" height="400"></video>
					<canvas id="canvas" width="600" height="400"></canvas>
					<div class="m_scan"></div>
	            </div>
	            <div class="faceinfo">
	            	<div class="box_snap">
	            		<p>图片抓取结果</p>
	            		<img id='img' src='' />
	            	</div>
	            	<button class="btn_snap">点击抓拍</button>
	            	请输入用户名：<input type="text" id="user_input" />
	            </div>
	            <button class="btn_submit" id="btn_submit">提交</button> 
            </div>
               
        </body>
        <script type="text/javascript" src="./js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript">
        	var video = document.getElementById("video");
        	var canvas = document.getElementById("canvas");
        	var img = document.getElementById("img");
        	$(function(){
        		//初始化摄像头
        		init_getvideo();
        		//点击按钮
        		$(".btn_snap").click(function(){
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
        			//console.log(localMediaStream);
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
		        canvas.getContext('2d').drawImage(video, 0, 0, 360, 260);
		        //把canvas图像转为img图片
		        img.src = canvas.toDataURL("image/png");
		        //将字符串截取
		        var base64 = img.src.split("base64,")[1];
		        $("#btn_submit").click(function(){
			        if(null!=$("#user_input").val() && ""!=$("#user_input").val()){
					    $.ajax({
							url: '/Face_Recognition/servlet/RegisterFace',
							type: 'POST',
							data:{img:base64,user:$("#user_input").val()},
							dataType: 'text',
							async: true,//异步
							timeout: 8000,
							error: function(){
								alert('操作错误,请与系统管理员联系!');
							},
							success: function(){
								alert("注册成功！");
							}
						});
			        }else{
			        	alert("用户名不能为空！");
			        }
				 });
		        	 
       		}
        </script>
 </html>