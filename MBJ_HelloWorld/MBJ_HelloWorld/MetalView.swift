//
//  MetalView.m
//  HelloWorld
//
//  Created by Warren Moore on 8/19/14.
//  Copyright (c) 2014 Metal By Example. All rights reserved.
//------------------------------------------------------------------------
//  converted to Swift by Jamnitzer (Jim Wrenholt)
//------------------------------------------------------------------------
import UIKit
import Metal

//------------------------------------------------------------------------------
class MetalView : UIView
{
    var metalLayer:CAMetalLayer! = nil
    var device:MTLDevice! = nil
    
    //-------------------------------------------------------------------------
    override class func layerClass() -> AnyClass
    {
        return CAMetalLayer.self
    }
    //-------------------------------------------------------------------------
    override init(frame: CGRect) // default initializer
    {
        super.init(frame: frame)
        self.initCommon()
    }
    //-------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initCommon()
    }
    //-------------------------------------------------------------------------
    func initCommon()
    {
        metalLayer = self.layer as? CAMetalLayer
        if (metalLayer == nil)
        {
            print("NO metalLayer HERE")
        }
        device = MTLCreateSystemDefaultDevice()
        metalLayer?.device = device           // 2
        metalLayer?.pixelFormat = .BGRA8Unorm // 3
        //-----------------------------------------------------------------
   }
    //-------------------------------------------------------------------------
    override func didMoveToWindow()
    {
        redraw()
    }
    //-------------------------------------------------------------------------
    func redraw()
    {
        //-----------------------------------------------------------
        // render layer.
        //-----------------------------------------------------------
        let drawable:CAMetalDrawable = metalLayer.nextDrawable()!
        let texture:MTLTexture = drawable.texture
        //
        //------------------------------------------------
        // renderPass destination texture buffer.
        //------------------------------------------------
        let renderPass = MTLRenderPassDescriptor()
        renderPass.colorAttachments[0].texture = texture
        renderPass.colorAttachments[0].loadAction = MTLLoadAction.Clear
        renderPass.colorAttachments[0].storeAction = MTLStoreAction.Store
        renderPass.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0)
        //------------------------------------------------
        let commandQueue = device!.newCommandQueue()
        let commandBuffer:MTLCommandBuffer = commandQueue.commandBuffer()
        let commandEncoder:MTLRenderCommandEncoder =
        commandBuffer.renderCommandEncoderWithDescriptor(renderPass)
        //------------------------------------------------
        commandEncoder.endEncoding()
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
        //------------------------------------------------
    }
    //-------------------------------------------------------------------------
}
//------------------------------------------------------------------------------
