/**
 * Namespace Api
 *
 * All backend api type
 */
declare namespace Api {
  namespace Common {
    /** common params of paginating */
    interface PaginatingCommonParams {
      /** current page number */
      pageNum: number;
      /** page size */
      pageSize?: number;
      /** total count */
      total: number;
    }

    /** common params of paginating query list data */
    interface PaginatingQueryRecord<T = any> extends PaginatingCommonParams {
      rows: T[];
    }

    /** common search params of table */
    type CommonSearchParams = Pick<Common.PaginatingCommonParams, 'pageNum' | 'pageSize'> &
      CommonType.RecordNullable<{
        orderByColumn: string;
        isAsc: 'asc' | 'desc';
        params: { [key: string]: any };
      }>;

    /**
     * 启用状态
     *
     * - "0": 正常
     * - "1": 停用
     */
    type EnableStatus = '0' | '1';

    /**
     * 显示状态
     *
     * - "0": 显示
     * - "1": 隐藏
     */
    type VisibleStatus = '0' | '1';

    /**
     * 是否状态
     *
     * - "Y": 是
     * - "N": 否
     */
    type YesOrNoStatus = 'Y' | 'N';

    /** common record（审计字段：后端多数 VO 只返回 createTime，createBy/updateBy 为用户 ID） */
    type CommonRecord<T = any> = {
      /** record creator（用户 ID） */
      createBy?: CommonType.IdType;
      /** record dept（部门 ID） */
      createDept?: CommonType.IdType;
      /** record create time */
      createTime: string;
      /** record updater（用户 ID） */
      updateBy?: CommonType.IdType;
      /** record update time */
      updateTime?: string;
    } & T;

    /** common tree record（后端 hutool Tree 序列化结构） */
    type CommonTreeRecord = {
      /** record id */
      id: CommonType.IdType;
      /** record parent id */
      parentId: CommonType.IdType;
      /** record label */
      label: string;
      /** record weight */
      weight: number;
      /** record children */
      children?: CommonTreeRecord[];
    }[];
  }
}
