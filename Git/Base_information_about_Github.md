# Git 使用规范流程

Git 是一个源码管理系统。

Git 的使用推荐采取ThoughtBot 的Git使用规范流程：

 ![1](pic\20160812\1.jpg)



## 第一步：新建分支

首先，每次开发新功能，都应该新建一个单独的分支。

```
#获取主干最新代码
$ git checkout master
$ git pull

#新建一个开发分支myfeature
$ git checkout -b myfeature
```

**怎样才能够使用这些命令？**

## 第二步：提交分支commit

分支修改后，就可以提交commit 了。

```javascript
$ git add --all
$ git status
$ git commit --verbose
```

git add 命令的all参数，表示保存所有变化(包括新建、修改和删除)。all 是 git add 的默认参数，所以也可以用git add . 代替。

git status 命令，用来查看发生变动的文件。

git commit 命令的verbose 参数，会列出diff 的结果。

**附：diff是什么东西**

diff 是 Unix 系统的一个很重要的工具程序，详细情况之后学习。

http://www.ruanyifeng.com/blog/2012/08/how_to_read_diff.html

## 第三步：撰写提交信息

提交commit时，必须给出完整扼要的提交信息。以下是一个范本：

```
Persent-tense summary under 50 characters

*More information about commit(under 72 characters)
*More information about commit(under 72 characters)

http://project.management-system.com/ticket/123
```

第一行是不超过50个字的提要，然后空一行，罗列出改动原因、主要变动、需要注意的问题。最后，提供对应的网址。

## 第四步：与主干同步

分支的开发过程中，要经常与主干保持同步。

```
$ git fetch origin
$ git rebase origin/master
```

## 第五步：合并commit

分支开发完成后，很可能有一堆commit，但是合并到主干的时候，往往希望只有一个(或最多两三个) commit，这样不仅清晰，也容易管理。

怎样才能将多个commit合并呢？这就要用到git rebase 命令。

```
$ git rebase -i origin/master
```

详情参考：http://www.ruanyifeng.com/blog/2015/08/git-use-process.html

## 第六步：推送到远程仓库

合并commit后，就可以推送当前分支到远程仓库了。

```
$ git push --force origin myfeature
```

git push 命令要加上force 参数，因为rebase以后，分支历史改变了，跟远程分支不一定兼容，（**此处不太理解**），有可能要强行推送。

详情参考：http://willi.am/blog/2014/08/12/the-dark-side-of-the-force-push/

## 第七步：发出Pull Request

提交到远程仓库以后，就可以发出Pull Request 到master 分支，然后请求别人进行代码review，确认可以合并到master。



# 常用Git 命令清单

一般来说，日常使用只要记住下图六个命令，就可以了。但是熟练使用，恐怕要记住60~100个命令。

 ![2](pic\20160812\2.jpg)

更多详情，参考：http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html



# Git 工作流程

Git 作为一个源码管理系统，不可避免涉及到多人协作。

协作必须有一个规范的工作流程，让大家有效地合作，使得项目井井有条地发展下去。

 ![3](pic\20160812\3.jpg)

以下介绍三种广泛使用的工作流程：

```
* Git flow
* Github flow
* Gitlab flow
```

## 一、功能驱动

上述介绍的三种工作流程，有一个共同点：都采用“功能驱动式开发”（Feature-driven development, 简称FDD）。

它指的是，需求是开发的起点，先有需求再有功能分支(feature branch) 或者补丁分支(hotfix branch)。完成开发后，该分支就合并到主分支，然后被删除。

## 二、Git flow

最早诞生、并得到广泛采用的一种工作流程，就是Git flow。

### 特点

它最为主要的特点有两个。

 ![4](pic\20160812\4.jpg)



首先，项目存在两个长期分支。

```
* 主分支 master
* 开发分支 develop
```

前者用于存放对外发布的版本，任何时候在这个分支拿到的，都是稳定的发布版；后者用于日常开发，存放最新的开发版。

其次，项目存在三种短期分支。

```
* 功能分支 (feature branch)
* 补丁分支 (hotfix branch)
* 预发分支 (release branch)
```

一旦完成开发，它们就会被合并进develop 或master，然后被删除。

详情请参考http://www.ruanyifeng.com/blog/2012/07/git.html

### 评价

Git flow 的优点是清晰可控，缺点是相对复杂，需要同时维护两个长期分支。大多数工具都将master 当作默认分支，可是开发是在develop分支进行的，这导致经常要切换分支，非常麻烦。

更大问题在于，这个模式是基于“版本发布”的，目标是一段时间以后产出一个新版本。但是，很多网站项目是“持续发布”，代码一有变动，就部署一次。这时，master分支和develop分支的差别不大，没必要维护两个长期分支。

## Github flow

Github flow 是Git flow 的简化版，专门配合“持续发布”。它是Github.com 使用的工作流程。

### 流程

它只有一个长期分支，就是master，因此用起来非常简单。

官方推荐的流程如下：

 ![5](pic\20160812\5.jpg)

```
第一步：根据需求，从master 拉出新分支，不区分功能分支或补丁分支；
第二步：新分支开发完成后，或者需要讨论的时候，就向master发起一个pull request；
第三步：Pull Request 既是一个通知，让别人注意到你的请求，又是一种对话机制，大家一起评审和讨论你的代码。对话过程中，你还可以不断提交代码；
第四步：你的Pull Request 被接受，合并进master，重新部署后，原来你拉进来的那个分支就被删除（先部署再合并也可）
```



### 评价

Github flow 的最大优点就是简单，对于“持续发布”的产品，可以说是最合适的流程。

问题在于它的假设：master分支的更新与产品的发布是不一致的。也就是说，master分支的最新代码，默认就是当前的线上代码。

可是，有的时候并非如此，代码合并进入master分支，并不代表它就能立即发布。比如，苹果商店的APP提交审核以后，等一段时间才能上架。这时，如果还有新的代码提交，master分支就会与刚发布的版本不一致。另一个例子是，有些公司有发布窗口，只有制定时间才能发布，这也会导致线上版本落后于master分支。

上面这种情况，只要master 一个主分支就不够用了。通常，你不得不在master分支以外，另外新建一个production 分支跟踪线上版本。

## Gitlab flow

Gitlab flow 是Git flow 与Github flow 的综合。它吸取了两者的优点，既有适应不同开发环境的弹性，又有单一主分支的简单与便利。它是Gitlab.com 推荐的做法。

### 上游优先

Gitlab flow 最大原则叫做上游优先(upstream first), 即只存在一个主分支master，它是所有其他分支的“上游”。只有上游分支采纳的代码变化，才能应用到其他分支。

实例可见Chromium项目。

它明确规定，上游分支依次为：

```
1. Linus Torvalds 的分支
2. 子系统（比如nerdev）的分支
3. 设备厂商（比如三星）的分支
```

**此部分目前较为难以理解，之后进行深入分析**

### 持续发布

Gitlab flow 分成两种情况，适应不同的开发流程。

 ![6](pic\20160812\6.jpg)



对于“持续发布”的项目，它建议在master分支以外，再建立不同的环境分支。比如，“开发环境”的分支是master， “预发环境”的分支是pre-production，“生产环境”的分支是production。

开发分支是预发分支的“上游”，预发分支又是产生分支的“上游”。代码的变化，必须由“上游”向“下游”发展。比如，生产环境出现bug，这时就要新建一个功能分支，先把它合并到master，确认没有问题，在cherry-pick到per-production，这一步也没有问题，才进入production。

只有紧急情况，才允许跳过上游，直接合并到下游分支。

### 版本发布

 ![7](pic\20160812\7.jpg)

对于“版本发布”的项目，建议的做法是每一个稳定版本，都要从master分支拉出一个分支，比如2-3-stable、2-4-stable等等。

以后，只有修补bug，才允许将代码合并到这些分支，并且此时要更新小版本号。

# 一些小技巧

## pull request

功能分支合并进master分支，必须通过pull request(Gitlab 里面叫做Merge Request)

 ![8](pic\20160812\8.jpg)

前面讲过，Pull Request 本质是一种对话机制，你可以在提交的时候，@相关人员或团队，引起他们的注意。

## protected branch

master 分支应该受到保护，不是每个人都可以修改这个分支，以及拥有审批Pull Request 的权利。

Github 和 Gitlab 都提供“保护分支”(protected branch) 这个功能。

### Issue

Issue 用于Bug 追踪和需求管理。建议先新建Issue，再新建对应的功能分支。功能分支总是为了解决一个或多个Issue。

功能分支的名称，可以与issue的名字保持一致，并且以issue的编号起首，比如“15-require-a-password-to-change-it”.

**“practice”**

开发完成后，在提交说明里面，可以写上“fixed #14” 或者 “closes # 67”。 Github 规定，只要commit message 里面有下面这些动词 + 编号，就会关闭对应的issue。

```
* close
* closes
* closed
* fix
* fixes
* fixed
* resolve
* resolves
* resolved
```

这种方式还可以一次关闭多个issue，或者关闭其他代码库的issue，格式是：

```
username/repository#issue_number
```

Pull Request 被接受以后，issue 关闭，原始分支就应该删除。如果以后该issue重新打开，新分支可以复用原来的名字。

### Merge 结点

Git 有两种合并：一种是“直进式合并”（fast forward）, 不生成单独的合并结点；另一种是“非直进式合并”(none fast forward), 会生成单独结点。

前者不利于保持commit 信息的清晰，也不利于以后的回滚，建议总是采用后者（即使用--no-ff参数）。只要发生合并，就要有一个单独的合并结点。

**practice**

### Squash 多个 commit

为了便于他人阅读你的提交，也便于cherry-pick 或撤销代码变化，在发起Pull Request 之前，应该把多个commit合并成一个。

（前提是，该分支只有你一个人开发，且没有跟master合并过。）











