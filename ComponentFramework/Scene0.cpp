#include <glew.h>
#include <iostream>
#include "Debug.h"
#include "Scene0.h"
#include "MMath.h"
#include "Debug.h"
#include "VulkanRenderer.h"
#include "OpenGLRenderer.h"
#include "Camera.h"

Scene0::Scene0(Renderer *renderer_): 
	Scene(nullptr),renderer(renderer_), camera(nullptr) {
	camera = new Camera();
	Debug::Info("Created Scene0: ", __FILE__, __LINE__);
}

Scene0::~Scene0() {
	if(camera) delete camera;

}

bool Scene0::OnCreate() {
	int width = 0, height = 0;
	float aspectRatio;
	switch (renderer->getRendererType()){
	case RendererType::VULKAN:
		
		SDL_GetWindowSize(dynamic_cast<VulkanRenderer*>(renderer)->GetWindow(), &width, &height);
		aspectRatio = static_cast<float>(width) / static_cast<float>(height);
		camera->Perspective(100.0f, aspectRatio, 0.5f, 20.0f);
		camera->LookAt(Vec3(0.0f, 0.0f, 5.0f), Vec3(0.0f, 0.0f, 0.0f), Vec3(0.0f, 1.0f, 0.0f));
		planeMatrix = MMath::translate(Vec3(-4.0f, 0.0f, 0.0f)) * MMath::rotate(45.0f, 0.0f, 1.0f, 0.0f) * MMath::scale(3.0f,3.0f,3.0f);
		break;

	case RendererType::OPENGL:
		break;
	}

	return true;
}

void Scene0::HandleEvents(const SDL_Event& sdlEvent) {
	if (sdlEvent.type == SDL_WINDOWEVENT) {
		switch (sdlEvent.window.event) {
		case SDL_WINDOWEVENT_SIZE_CHANGED:
			printf("size changed %d %d\n", sdlEvent.window.data1, sdlEvent.window.data2);
			float aspectRatio = static_cast<float>(sdlEvent.window.data1) / static_cast<float>(sdlEvent.window.data2);
			camera->Perspective(45.0f, aspectRatio, 0.5f, 20.0f);
			if(renderer->getRendererType() == RendererType::VULKAN){
				dynamic_cast<VulkanRenderer*>(renderer)->RecreateSwapChain();
			}
			break;
		}
	}
}
void Scene0::Update(const float deltaTime) {
	static float elapsedTime = 0.0f;
	elapsedTime += deltaTime;
	mariosModelMatrix = MMath::rotate(elapsedTime * 90.0f, Vec3(0.0f, 1.0f, 0.0f));
	mariosModelMatrix2 = MMath::translate(Vec3(2.0f, 0.0f, -5.0f));
	mariosModelMatrix2 *= MMath::rotate(elapsedTime * 90.0f, Vec3(0.0f, -1.0f, 0.0f));
	mariosModelMatrix3 = MMath::translate(Vec3(-2.0f, 0.0f, 0.0f));
	mariosModelMatrix3 *= MMath::rotate(elapsedTime * 90.0f, Vec3(1.0f, 0.0f, 0.0f));
	mariosModelMatrix4 = MMath::translate(Vec3(0.0f, 2.0f, 0.0f));
	mariosModelMatrix4 *= MMath::rotate(elapsedTime * 90.0f, Vec3(1.0f, 0.0f, 0.0f));
	planeMatrix *= MMath::translate(Vec3(0.0f, 0.0f, -0.01f));


	//planeMatrix *= MMath::rotate(elapsedTime * 1.0f, Vec3(1.0f, 0.0f, 0.0f));

}

void Scene0::Render() const {
	
	switch (renderer->getRendererType()) {

	case RendererType::VULKAN:
		VulkanRenderer* vRenderer;
		vRenderer = dynamic_cast<VulkanRenderer*>(renderer);
		vRenderer->SetCameraUBO(camera->GetProjectionMatrix(), camera->GetViewMatrix());
		vRenderer->SetPushConstant(mariosModelMatrix, 0);
		vRenderer->SetPushConstant(mariosModelMatrix2, 1);
		vRenderer->SetPushConstant(mariosModelMatrix3, 2);
		vRenderer->SetPushConstant(mariosModelMatrix4, 3);
		vRenderer->SetMatrixUBO(planeMatrix, camera->GetProjectionMatrix(), camera->GetViewMatrix());
		vRenderer->SetLightUBO(Vec4(20.0f, 0.0f, 1.0f, 0.0f), Vec4(0.9, 0.0, 0.0, 0.0), Vec4(0.9, 0.0, 0.0, 0.0), float(0.1), 0); // creates multiple lights, values used in simplePhong.vert/frag
		vRenderer->SetLightUBO(Vec4(-20.0f, 0.0f, 1.0f, 0.0f), Vec4(0.0, 0.9, 0.0, 0.0), Vec4(0.0, 0.9, 0.0, 0.0), float(0.1), 1);
		vRenderer->SetLightUBO(Vec4(0.0f, 20.0f, 1.0f, 0.0f), Vec4(0.0, 0.0, 0.9, 0.0), Vec4(0.0, 0.0, 0.9, 0.0), float(0.1), 2);
		vRenderer->Render();
		break;

	case RendererType::OPENGL:
		OpenGLRenderer* glRenderer;
		glRenderer = dynamic_cast<OpenGLRenderer*>(renderer);
		/// Clear the screen
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_CULL_FACE);
		/// Draw your scene here
		
		
		glUseProgram(0);
		
		break;
	}
}


void Scene0::OnDestroy() {
	
}
