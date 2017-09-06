<?php

/**
 * Copyright (c) 2017,上海二三四五网络科技股份有限公司
 * 文件名称：ChannelController.cls.php
 * 摘    要：获取渠道的app类型id
 * 作    者：林永杰
 * 修改日期：2017.06.16
 */

include(ROOT_PATH . '/controllers/ios/base/IosController.cls.php');
class ChannelController extends IosController
{
    /**
     * 获取渠道的app号
     * @author hujing
     * @DateTime 2017-04-14T16:07:27+0800
     * @return   [type]                   [description]
     */
    public function indexAction()
    {
        $this->apiCtrl(__CLASS__, __FUNCTION__);
        $this->echoResult(1, 'channel', array('is_check' => '0', 'app_version' => '1.0.1'));
    }


}
