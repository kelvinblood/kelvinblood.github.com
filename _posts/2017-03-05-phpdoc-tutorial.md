---
layout: post
title: PHPDoc 入门
category: tech
tags: php intellij
---

![](https://cdn.kelu.org/blog/tags/php.jpg)

# [概况][first]

这篇文章的目标是了解 PHPDoc 的使用，文末附上了两个开源项目作为参考。关于 PHPDoc 的安装办法可以查看[上一篇文章](/tech/2017/03/04/phpdoc-install.html)。

DocBlocks 以注释的形式出现，但又不仅仅是注释。它是一份行内的文档，可以让你回想起这一块代码是用来干什么的，phpdoc也根据它来生成文档。

DocBlock使用范围包括

* 函数（function）
* 常量
* 类
* 接口
* trait
* 类内常量
* 类属性
* 类方法(method)
* include require

一个标准的 DocBlock 像这样子：

     <?php
     /**
      * 这是关于这个function的总结。
      *
      * 这是关于function的 *详细描述* 。
      * 可以使用markdown样式
      *
      * @param 这是输入标签。
      *    下面的return是返回值标签。
      *
      * @return void
      */
      function myFunction($myArgument)
      {
      }

# [运行][run]

    $ phpdoc -d path/to/my/project -f path/to/an/additional/file -t path/to/my/output/folder
    
运行phpdoc时，需要指定扫描的文件夹或者文件，或者事先在配置文件 phpdoc.xml 中声明。 如果没有指定导出文件夹，则默认导出到当前目录下的output。

配置文件 phpdoc.xml 一般放在项目目录下。全局配置文件 phpdoc.dist.xml 在 phpdoc 的安装目录下，也可以修改。

# [模板][changing_the_look]

模板文件在 PHPDoc 的安装目录的 data\templates 目录下。

    $ phpdoc -d "./src" -t "./docs/api" --template="checkstyle"  // 使用一个模板
    $ phpdoc -d "./src" -t "./docs/api" --template="checkstyle,clean" // 使用多个模板
    $ phpdoc -d "./src" -t "./docs/api" --template="data/templates/my_template" // 使用自定义模板
    
我们可以使用 XSL 或者 Twig 模版引擎来自定义模板。phpDoc 提供了很多便利的方法。希望自定义折腾的可以去[试试][changing_the_look]。默认的模板clean我并不喜欢，我选了颜值最高的responsive模板。样式如下：

     phpdoc --template="responsive" -d ./app -t ./docs

![](https://cdn.kelu.org/blog/2017/03/responsive.jpg)
    
# [与IntelliJ IDEA结合][idea]

大部分人写代码还是需要IDE的。可以帮忙做诸如自动补全、预编译报警等等很多事情，减少问题，加快开发进度。我常用的是 JetBrains 厂的 IntelliJ Idea。 PHPDoc 和 IDEA 的结合还是蛮可以的。从 PHPDoc 的官网上就可以看出来, JeyBrains 还是他们的赞助商。
    
一些简单的使用方法可以在 [Idea 官网][idea]找到。最常用的就是在方法或者类名之前输入 `/**` 后按回车键，自动将常用的 Tag 给写好了。

除了写代码时的便利，导出也可以借由 [IDEA](https://www.jetbrains.com/help/idea/2016.3/creating-and-editing-run-debug-configurations.html) 完成。

菜单栏 Run -> Edit Configurations,增加php脚本配置。在 File 栏目填写 phpdoc 的路径，例如我的 `C:\my_pp\php\php-5.5.30-nts-Win32-VC11-x64\phpdoc`,在 Arguments 栏目填写运行变量，例如我的 `--template="responsive" -d "C:\Workspace\wechat.kelu.org\app" -t "C:\Workspace\wechat.kelu.org\docs"`
    
![](https://cdn.kelu.org/blog/2017/03/idea_run_config.jpg)
    
# Docblocks详解

Docblocks 使用 Tag 的形式来标记。

| 标记 | 用途 | 描述 | 
| --- |  --- |  --- | 
| @abstract |  | 抽象类的变量和方法 | 
| @access | public, private or protected | 文档的访问、使用权限. @access private 表明这个文档是被保护的。 | 
| @author | 张三 <zhangsan@163.com> | 文档作者 | 
| @copyright | 名称 时间 | 文档版权信息 | 
| @deprecated | version | 文档中被废除的方法 | 
| @deprec |  | 同 @deprecated | 
| @example | /path/to/example | 文档的外部保存的示例文件的位置。 | 
| @exception |  | 文档中方法抛出的异常，也可参照 @throws. | 
| @global | 类型：$globalvarname | 文档中的全局变量及有关的方法和函数 | 
| @ignore |  | 忽略文档中指定的关键字 | 
| @internal |  | 开发团队内部信息 | 
| @link | URL | 类似于license 但还可以通过link找到文档中的更多个详细的信息 | 
| @name | 变量别名 | 为某个变量指定别名 | 
| @magic |  | phpdoc.de compatibility | 
| @package | 封装包的名称 | 一组相关类、函数封装的包名称 | 
| @param | 如 [$username] 用户名 | 变量含义注释 | 
| @return | 如 返回bool | 函数返回结果描述，一般不用在void（空返回结果的）的函数中 | 
| @see | 如 Class Login（） | 文件关联的任何元素（全局变量，包括，页面，类，函数，定义，方法，变量）。 | 
| @since | version | 记录什么时候对文档的哪些部分进行了更改 | 
| @static |  | 记录静态类、方法 | 
| @staticvar |  | 在类、函数中使用的静态变量 | 
| @subpackage |  | 子版本 | 
| @throws |  | 某一方法抛出的异常 | 
| @todo |  | 表示文件未完成或者要完善的地方 | 
| @var | type | 文档中的变量及其类型 | 
| @version |  | 文档、类、函数的版本信息 | 


# 实例参考

下面参考一下两个开源项目的 DocBlocks。

1. [October](https://github.com/octobercms/october)

        /**
         * Administrator user model
         *
         * @package october\backend
         * @author Alexey Bobkov, Samuel Georges
         */
        class User extends UserBase
        {
            /**
             * @var string The database table used by the model.
             */
            protected $table = 'backend_users';

            /**
             * Validation rules
             */
            public $rules = [
                'email' => 'required|between:6,255|email|unique:backend_users',
                'login' => 'required|between:2,255|unique:backend_users',
                'password' => 'required:create|between:4,255|confirmed',
                'password_confirmation' => 'required_with:password|between:4,255'
            ];

            /**
             * Relations
             */
            public $belongsToMany = [
                'groups' => ['Backend\Models\UserGroup', 'table' => 'backend_users_groups']
            ];

            public $attachOne = [
                'avatar' => ['System\Models\File']
            ];

            /**
             * Purge attributes from data set.
             */
            protected $purgeable = ['password_confirmation', 'send_invite'];

            /**
             * @var string Login attribute
             */
            public static $loginAttribute = 'login';

            /**
             * @return string Returns the user's full name.
             */
            public function getFullNameAttribute()
            {
                return trim($this->first_name . ' ' . $this->last_name);
            }

            /**
             * Gets a code for when the user is persisted to a cookie or session which identifies the user.
             * @return string
             */
            public function getPersistCode()
            {
                // Option A: @todo config
                // return parent::getPersistCode();

                // Option B:
                if (!$this->persist_code) {
                    return parent::getPersistCode();
                }

                return $this->persist_code;
            }
            ......
        }


1. [BootstrapCMS](https://github.com/BootstrapCMS/CMS)

    这个项目的开发者也是 laravel 开发组成员。

        /*
         * This file is part of Bootstrap CMS.
         *
         * (c) Graham Campbell <graham@alt-three.com>
         *
         * For the full copyright and license information, please view the LICENSE
         * file that was distributed with this source code.
         */

        namespace GrahamCampbell\BootstrapCMS\Models\Relations;

        /**
         * This is the has many comments trait.
         *
         * @author Graham Campbell <graham@alt-three.com>
         */
        trait HasManyCommentsTrait
        {
            /**
             * Get the comment relation.
             *
             * @return \Illuminate\Database\Eloquent\Relations\HasOneOrMany
             */
            public function comments()
            {
                return $this->hasMany('GrahamCampbell\BootstrapCMS\Models\Comment');
            }

            /**
             * Delete all comments.
             *
             * @return void
             */
            public function deleteComments()
            {
                foreach ($this->comments()->get(['id']) as $comment) {
                    $comment->delete();
                }
            }
        }

# 参考资料


* [PHPDoc 官网](https://phpdoc.org)
* [PHP的Annotations](https://xuwenzhi.com/2016/07/23/php的annotations)

[first]: https://phpdoc.org/docs/latest/getting-started/your-first-set-of-documentation.html
[run]: https://phpdoc.org/docs/latest/guides/running-phpdocumentor.html
[changing_the_look]: https://phpdoc.org/docs/latest/getting-started/changing-the-look-and-feel.html
[idea]: https://www.jetbrains.com/help/idea/2016.3/creating-php-documentation-comments.html
