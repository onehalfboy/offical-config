<?php
/**
 * Copyright (c) 2012,上海2345网络科技股份有限公司
 * 摘 要：后台首页
 * 作 者：wangzb
 * 修改日期：2014.07.01
 */
include ('BaseController.cls.php');
class IndexController extends BaseController
{
    const PAGE_SIZE = 50;

	private $_appModel, $_unionDataModel, $_adminModel;
	private $_startDate;
	private $_endDate;
    
	public function __construct()
	{
		parent::__construct();
		$this->_appModel = System::loadModel('AppModel');
		$this->_unionDataModel = System::loadModel('UnionDataModel');
        $this->_adminModel = System::loadModel('AdminModel');
        $this->_initDate();
	}
    
    /**
     * 权限控制
     * @return array
     */
    public function accessRules()
    {
        return array(
            'allow' => array(
                'index',
                'header',
                'left',
                'main',
            ),
        );
    }
    
    /**
     * 初始化时间
     */
    private function _initDate()
	{
		$this->_startDate = isset($_REQUEST['start_date']) && !empty($_REQUEST['start_date']) ?
                date('Y-m-d', strtotime(trim($_REQUEST['start_date']))) :
                date('Y-m-d', strtotime('-7 day'));
        $this->_endDate = isset($_REQUEST['end_date']) && !empty($_REQUEST['end_date']) ?
                date('Y-m-d', strtotime(trim($_REQUEST['end_date']))) :
                date('Y-m-d', strtotime('-1 day'));
    }
	
	/**
	 * 首页
	 */
	public function indexAction()
	{
		$this->render('admin/index.tpl.html');
	}
	
	/**
	 * OA头部
	 */
	public function headerAction()
	{
		$pageArray['global_header'] = $this->_getGlobalHeader('', $_SESSION['global_oa_uid'], $_SESSION['global_oa_mk']);
        $pageArray['global_header'] = mb_convert_encoding($pageArray['global_header'], 'utf-8', 'gbk');
        $this->render('admin/header.tpl.html', $pageArray);
	}
	
	/**
	 * 左侧菜单
	 */
	public function leftAction()
	{
        $adminMenuList = $this->getAdminMenuList(0);
        foreach($adminMenuList as $key => $row)
        {
            $tmpList = $this->getAdminMenuList($row['id']);
            $adminMenuList[$key]['level2_menu'] = $tmpList;
        }
        $pageArray['admin_menu_list'] = $adminMenuList;
		$this->render('admin/left.tpl.html', $pageArray);
	}
	
	/**
	 * 右侧主题
     * @TODO 上级用户看到的汇总数据不是他下面人的汇总数据，而是同管理员一样，看到的所有汇总数据的总和
	 */
	public function mainAction()
	{
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $params = array(
            'start_date' => $this->_startDate,
            'end_date'   => $this->_endDate,
            'admin_id'   => isset($_REQUEST['admin_id']) ? $_REQUEST['admin_id'] : 0,
            'app_id'     => isset($_REQUEST['app_id']) ? $_REQUEST['app_id'] : 0,
        );
            
		$list = array();
        $appList = $this->_appModel->getAllAppList();
		foreach($appList as $row)
		{
            //当查询选中的app时
            if (!empty($_REQUEST['app_id']) && $_REQUEST['app_id'] != $row['id'])
            {
                continue;
            }

            $tmpList = array();
            $limit = '';
			$totalCount = $this->_getRecords($row['id'], TRUE);
			if($totalCount > 0)
			{
				$totalPage = ceil($totalCount / self::PAGE_SIZE);
				$page = max($page, 1);
				$page = min($page, $totalPage);
				$start = ($page - 1) * self::PAGE_SIZE;
				$limit = " LIMIT $start, " . self::PAGE_SIZE;
                
				$tmpList = $this->_getRecords($row['id'], FALSE, $limit);
			}
            //阅读王  消费金额和结算金额两个字段处理一下
            if($row['id'] == '14')
            {
                foreach ($tmpList as $key => $value)
                {
                    $tmpList[$key]['consume'] = sprintf('%.2f', $value['consume'] / 100);
                    $tmpList[$key]['settle_amount'] = sprintf('%.2f', $value['settle_amount'] / 100);                    
                }
            }
			$list[$row['app_code']]['list'] = $tmpList;
			$list[$row['app_code']]['app_name'] = $row['app_name'];
			//合计数据
			$total = $this->_getRecordsTotal($row['id'], $limit);
            //阅读王  消费金额和结算金额两个字段处理一下
            if($row['id'] == '14')
            {
                $total['total_consume'] = sprintf('%.2f', $total['total_consume'] / 100);
                $total['total_settle_amount'] = sprintf('%.2f', $total['total_settle_amount'] / 100);
            }
			$list[$row['app_code']]['total'] = $total;
			$list[$row['app_code']]['pages'] = getPages($totalCount, $page, self::PAGE_SIZE, 'index.php?m=admin&c=index&a=main', $params);
		}
        $pageArray = array(
            'params' => $params,
            'list' => $list,
            'app_list' => $appList,
            'admin_list' => $this->getSearchAdminList($_SESSION['admin_id']),
        );
		$this->render('admin/main.tpl.html', $pageArray);
	}
    
    /**
     * 获取记录
     * @param bool $getCount 是否是获取记录总数
     * @param string $limit 
     * @return mixed
     */
    private function _getRecords($appId, $getCount = FALSE, $limit = '')
    {
        $buildWhereArr = $this->_buildWhere('A', $appId);
        $strWhere = $buildWhereArr[0];
        $params = $buildWhereArr[1];
        $fields = $getCount ? 'COUNT(*) as total_num' : 'A.*, B.`admin_name`';
        $sql = "SELECT $fields FROM `tab_union_data` A";
        $sql .= " LEFT JOIN `tab_admin` B ON `A`.`admin_id` = `B`.id";
        $sql .= " $strWhere ORDER BY A.`v_date` DESC";
        $sql .= $limit ? $limit : '';
//        echo $sql . '<br>';
//        exit;
        if ($getCount)
        {
            $result = $this->_unionDataModel->pdo->find($sql, $params);
            $result = $result['total_num'];
        }
        else
        {
            $result = $this->_unionDataModel->pdo->findAll($sql, $params);
        }
        return $result;
    }
    
    private function _getRecordsTotal($appId, $limit = '')
    {
    	$buildWhereArr = $this->_buildWhere('A', $appId);
        $strWhere = $buildWhereArr[0];
        $params = $buildWhereArr[1];
    	$fields = 'SUM(A.union_num) AS total_union, SUM(A.union_num_new) AS total_union_new, SUM(A.new_num) AS total_new,  SUM(A.new_num_new) AS total_new_num_new, SUM(A.consume) AS total_consume, SUM(A.settle_amount) AS total_settle_amount, SUM(A.active_num) AS total_active, SUM(A.launch_num) AS total_launch, ROUND(SUM(A.launch_num)/SUM(A.active_num),2) AS launch_person, ROUND(SUM(A.avg_launch_duration)/COUNT(*)) AS launch_times';
    	$sql = "SELECT $fields FROM `tab_union_data` A";
    	$sql .= " $strWhere ORDER BY A.`v_date` DESC";
    	$sql .= $limit ? $limit : '';
    	//        echo $sql . '<br>';die;
    	$result = $this->_unionDataModel->pdo->find($sql, $params);
    	return $result;
    }

    /**
     * 创建where查询条件
     * @param string $alias 表别名
     * @return string 查询条件
     */
    private function _buildWhere($alias, $appId)
    {
        $strWhere = ' WHERE 1 ';
        $strWhere .= " AND  $alias.`app_id` = :app_id";
        $params = array(':app_id' => $appId);
        
        //如果是超级管理员
		if (in_array($_SESSION['group_flag'], array('super_admin')) || !empty($_SESSION['admin_info']['child']))
        {
            $adminList = $this->getSearchAdminList($_SESSION['admin_id']);
            if (isset($_REQUEST['admin_id']) && in_array($_REQUEST['admin_id'], array_keys($adminList)))
            {
                $adminId = (int)$_REQUEST['admin_id'];
            }
            else
            {
                $adminId = 0;
            }
        }
        else
        {
            $adminId = $_SESSION['admin_id'];
        }
        $strWhere .= " AND $alias.`admin_id` = :admin_id";
        $params[':admin_id'] = $adminId;
        
		if(!empty($this->_startDate) && empty($this->_endDate))
		{
			$strWhere .= " AND $alias.`v_date` = :v_date";
            $params[':v_date'] = $this->_startDate;
		}
		else if(!empty($this->_startDate) && !empty($this->_endDate))
		{
			$strWhere .= " AND  $alias.`v_date` >= :start_date AND   $alias.`v_date` <= :end_date";
            $params[':start_date'] = $this->_startDate;
            $params[':end_date'] = $this->_endDate;
        }
        
        return array($strWhere, $params);
    }

    /**
	 * 参 数：$from,string,来源
	 * $useranme,string,用户名
	 * $mk,string,加密串 算法：md5(UC_KEY.$uid)
	 * 作 者：wangzb
	 * 功 能：获取OA系统公用的头部
	 * 修改日期：2014-06-23
	 */
	public function _getGlobalHeader($from = '', $username = '', $mk = '')
	{
		$content = '';
		$content = @file_get_contents(OA_SITE . "/oaAllTop.php?from={$from}&userid={$username}&mk={$mk}&sysid=196");
        if (false === mb_check_encoding($content, 'GB2312'))
		{
			$content = mb_convert_encoding($content, 'GB2312', 'UTF-8');
		}
		return $content;
	}
}