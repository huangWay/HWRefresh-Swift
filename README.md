# HWRefresh-Swift
模仿MJRefresh写的SWift版(好吧是照抄的)，加多了UICollectionView的侧滑加载，还是OC的思路，纯当练手啦

对于UITableView，一般只有上下拉加载
table.addHeadRefresh {
    //刷新...
}
table.addFootRefresh {
    //刷新...
}
对于UICollectionView，多了左右滑动加载
collection.addLeftRefresh {
    //刷新...
}
collection.addRightRefresh { 
    //刷新...
}
